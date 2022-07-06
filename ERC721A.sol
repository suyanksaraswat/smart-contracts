// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SquareBears is ERC721A, Ownable{
    using Strings for uint256;

    string public baseURI;
    string public baseExtension = ".json";
    uint256 public maxSupply = 1001;
    uint256 public maxMintAmount = 1001;
    bool public paused = false;

    constructor(
      string memory _name,
      string memory _symbol,
      string memory _initBaseURI
    ) ERC721A(_name, _symbol) {
      setBaseURI(_initBaseURI);
    }

   function _baseURI() internal view virtual override returns (string memory) {
      return baseURI;
    }

    function mint(uint256 _mintAmount) public onlyOwner {
        uint256 supply = totalSupply();
        require(!paused);
        require(_mintAmount > 0);
        require(_mintAmount <= maxMintAmount);
        require(supply + _mintAmount <= maxSupply);

        _safeMint(msg.sender, _mintAmount);
    }
  
    function tokenURI(uint256 tokenId)
      public
      view
      virtual
      override
      returns (string memory)
    {
      require(
        _exists(tokenId),
        "ERC721Metadata: URI query for nonexistent token"
      );

      string memory currentBaseURI = _baseURI();
      return bytes(currentBaseURI).length > 0
          ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
          : "";
    }

    function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
      maxMintAmount = _newmaxMintAmount;
    }

    function setBaseURI(string memory _newBaseURI) public onlyOwner {
      baseURI = _newBaseURI;
    }

    function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
      baseExtension = _newBaseExtension;
    }

    function pause(bool _state) public onlyOwner {
      paused = _state;
    }
  
    function withdraw() public payable onlyOwner {
      // This will payout the owner 95% of the contract balance.
      // Do not remove this otherwise you will not be able to withdraw the funds.
      // =============================================================================
      (bool os, ) = payable(owner()).call{value: address(this).balance}("");
      require(os);
      // =============================================================================
    }
}