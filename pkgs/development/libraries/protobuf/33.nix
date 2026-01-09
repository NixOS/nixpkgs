{ callPackage, ... }@args:

callPackage ./generic.nix (
  {
    version = "33.2";
    hash = "sha256-SguWBa9VlE15C+eLzcqqusVLgx9kDyPXwYImSE75HCM=";
  }
  // args
)
