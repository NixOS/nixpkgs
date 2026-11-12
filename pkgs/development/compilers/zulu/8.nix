{ callPackage, ... }@args:

callPackage ./common.nix (
  {
    # Details from https://www.azul.com/downloads/?version=java-8-lts&package=jdk
    featureVersion = "8";
  }
  // removeAttrs args [ "callPackage" ]
)
