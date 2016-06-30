{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "1.1";
  sha256 = "06dzzr9g2qhy48yy50xgac9jadjmqjykl52fq2kfl2l7xxzykkkz";
})
