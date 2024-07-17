{ callPackage, ... }@args:

callPackage ./generic-v3.nix (
  {
    version = "3.20.3";
    sha256 = "sha256-u/1Yb8+mnDzc3OwirpGESuhjkuKPgqDAvlgo3uuzbbk=";
  }
  // args
)
