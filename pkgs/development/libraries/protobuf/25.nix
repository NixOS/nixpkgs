{ callPackage, ... }@args:

callPackage ./generic.nix (
  {
    version = "25.8";
    hash = "sha256-UUUblMKN1xFknFtanq5MRVQ57dzhOV9sPqlw1J37aNE=";
  }
  // args
)
