{ callPackage, ... }@args:

callPackage ./generic.nix (
  {
    version = "32.1";
    hash = "sha256-wfu1MyCycGpxFB++eicA0F41j886/Y52I/4+ciRUg2o=";
  }
  // args
)
