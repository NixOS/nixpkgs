{ callPackage, ... }@args:

callPackage ./generic.nix (
  {
    version = "30.0";
    hash = "sha256-DJhShzuyR7svzxx7hV8INBPFfU4B/0aFCM6foPOINvo=";
  }
  // args
)
