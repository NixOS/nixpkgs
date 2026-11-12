{ callPackage, ... }@args:

callPackage ./common.nix (
  {
    # Details from https://www.azul.com/downloads/?version=java-21-lts&package=jdk
    featureVersion = "21";
  }
  // removeAttrs args [ "callPackage" ]
)
