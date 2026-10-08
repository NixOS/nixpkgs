{ callPackage, ... }@args:

callPackage ./generic.nix (
  {
    version = "36.0";
    hash = "sha256-VGXFfqLm7IEJ9MQpMYhdVW5qPZbrYZ6q+0Y1TqQkjks=";
  }
  // args
)
