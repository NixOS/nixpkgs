{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  baseVersion = "3.3";
  revision = "0";
  hash = "sha256-No8R9CbxIFrtuenjI2ihZTXcEb1gNRBm5vZmTsNrhbk=";
})
