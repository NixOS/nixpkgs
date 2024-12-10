{ callPackage, ... }@args:

callPackage ./generic.nix (
  args
  // {
    baseVersion = "2.19";
    revision = "5";
    hash = "sha256-3+6g4KbybWckxK8B2pp7iEh62y2Bunxy/K9S21IsmtQ=";
  }
)
