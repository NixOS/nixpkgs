{ callPackage, ... }@args:

callPackage ./common.nix (
  {
    # Details from https://www.azul.com/downloads/?version=java-24&package=jdk
    featureVersion = "25";
  }
  // removeAttrs args [ "callPackage" ]
)
