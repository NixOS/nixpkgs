{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "${branch}.1";
  branch = "3.1";
  sha256 = "1d5knh87cgnla5zawy56gkrpb48qhyiq7i0pm8z9hyx3j05abg55";
})
