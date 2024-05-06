{ callPackage, ... }@args:

callPackage ./generic.nix (
  {
    version = "29.0";
    hash = "sha256-7t5aL8K8hRhE3V8YUQXQmihWMy+KGeS+msRakmonLUM=";
  }
  // args
)
