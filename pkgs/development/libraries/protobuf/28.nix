{ callPackage, ... }@args:

callPackage ./generic.nix (
  {
    version = "28.0";
    hash = "sha256-dAyXtBPeZAhmAOWbG1Phh57fqMmkH2AbDUr+8A+irJQ=";
  }
  // args
)
