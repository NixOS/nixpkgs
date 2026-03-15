{ callPackage, ... }@args:

callPackage ./generic.nix (
  {
    version = "34.0";
    hash = "sha256-qtSP3I7RA7F6tKe+VfGd+oNXMT5HZ/Xl7u4vkefNxX4=";
  }
  // args
)
