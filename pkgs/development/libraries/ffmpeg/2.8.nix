{ callPackage, ... } @ args:

callPackage ./generic.nix (rec {
  version = "${branch}.15";
  branch = "2.8";
  sha256 = "08gf493a1ici1rn6gda6bxkcsk3fqbs6pdr0phcifjkd3xn7yr1m";
} // args)
