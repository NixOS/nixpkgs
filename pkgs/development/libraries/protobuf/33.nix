{ callPackage, ... }@args:

callPackage ./generic.nix (
  {
    version = "33.3";
    hash = "sha256-why+EKsH19jSj6LmlUySidx6shbvpItVjWq5deH3EXw=";
  }
  // args
)
