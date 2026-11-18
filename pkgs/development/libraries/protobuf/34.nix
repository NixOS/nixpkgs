{ callPackage, ... }@args:

callPackage ./generic.nix (
  {
    version = "34.2";
    hash = "sha256-5YZ8Q9uy7MDnLRmLkkEuqp0k6eJRvs/nPfyo33cJLgs=";
  }
  // args
)
