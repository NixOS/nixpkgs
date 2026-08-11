{ callPackage, ... }@args:

callPackage ./generic.nix (
  {
    version = "35.1";
    hash = "sha256-nif9xjd+3ASR2pvvSXkzTEWoKi2oKLzV9gMQ3EevBVk=";
  }
  // args
)
