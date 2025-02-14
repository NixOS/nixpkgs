{ callPackage, ... }@args:

callPackage ./generic.nix (
  {
    version = "25.6";
    hash = "sha256-pXZGffQXjAUXworfcr75BrkADamC9pKZXNK0l/Bvk9g=";
  }
  // args
)
