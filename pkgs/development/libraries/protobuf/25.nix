{ callPackage, ... } @ args:

callPackage ./generic.nix ({
  version = "25.4";
  hash = "sha256-dIouv6QaX6Tlahjrdz250DJkKjZ74/EwoQjTs3vBS/U=";
} // args)
