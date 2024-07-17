{ callPackage, ... }@args:

callPackage ./generic.nix (
  {
    version = "25.3";
    hash = "sha256-N/mO9a6NyC0GwxY3/u1fbFbkfH7NTkyuIti6L3bc+7k=";
  }
  // args
)
