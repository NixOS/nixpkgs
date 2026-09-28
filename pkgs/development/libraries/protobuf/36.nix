{ callPackage, ... }@args:

callPackage ./generic.nix (
  {
    version = "36.2";
    hash = "sha256-sY9Pmy6KMJ5k/GdQSAF7vsviLJYPaArMKJ3deb++0wM=";
  }
  // args
)
