{ callPackage, ... }@args:

callPackage ./common.nix (
  {
    # Details from https://www.azul.com/downloads/?version=java-11-lts&package=jdk
    featureVersion = "11";
  }
  // removeAttrs args [ "callPackage" ]
)
