{ callPackage, ... }@args:

callPackage ./generic.nix (
  {
    version = "29.1";
    hash = "sha256-8vLDwMZUu7y0gK9wRJ9pAT6wI0n46I5bJo2G05uctS4=";
  }
  // args
)
