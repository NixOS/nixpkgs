{ callPackage, ... }@args:

callPackage ./generic.nix (
  {
    version = "27.5";
    hash = "sha256-wUXvdlz19VYpFGU9o0pap/PrwE2AkopLZJVUqfEpJVI=";
  }
  // args
)
