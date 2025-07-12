{ callPackage, ... }@args:

callPackage ./generic.nix (
  {
    version = "29.5";
    hash = "sha256-nraqBM87DJYU69Zx0dV9OMnI0Jhn8Axg8DvzUQDQ90Y=";
  }
  // args
)
