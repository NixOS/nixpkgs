{ callPackage, ... }@args:

callPackage ./common.nix (
  {
    # Details from https://www.azul.com/downloads/?version=java-27&package=jdk
    featureVersion = "27";
  }
  // removeAttrs args [ "callPackage" ]
)
