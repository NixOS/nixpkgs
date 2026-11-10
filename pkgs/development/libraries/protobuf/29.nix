{ callPackage, ... }@args:

callPackage ./generic.nix (
  {
    version = "29.6";
    hash = "sha256-IIFqEKOlyQMuxzW3HNhCNM/x1gYmW7gaNu7IxY3VMAU=";
  }
  // args
)
