{ callPackage, ... } @ args:

callPackage ./generic.nix ({
  version = "27.3";
  hash = "sha256-JZtRNGjAns1VJ+0831AzgOaBQkHAnnLxeXs4SoXlXpE=";
} // args)
