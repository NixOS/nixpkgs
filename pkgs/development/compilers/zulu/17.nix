{ callPackage, ... }@args:

callPackage ./common.nix (
  {
    # Details from https://www.azul.com/downloads/?version=java-17-lts&package=jdk
    featureVersion = "17";
  }
  // removeAttrs args [ "callPackage" ]
)
