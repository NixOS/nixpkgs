{ callPackage, ... }@args:

callPackage ./generic.nix (
  {
    version = "29.3";
    hash = "sha256-zdOBzLdN0ySrdFTF/X/NYI57kJ1ZFyoIl1/Qtgh/VkI=";
  }
  // args
)
