{ callPackage, ... }@args:

callPackage ./generic.nix (
  {
    version = "33.4";
    hash = "sha256-/mdniUtu6+tj2W8zYeV5xvEzMMfzKkGVk7Lc37p1+dE=";
  }
  // args
)
