{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  baseVersion = "3.4";
  revision = "0";
  hash = "sha256-cYQ6/MCixYX48z+jBPC1iuS5xdgwb4lGZ7N0YEQndVc=";
})
