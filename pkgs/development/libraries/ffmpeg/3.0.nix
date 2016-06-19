{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "${branch}.2";
  branch = "3.0";
  sha256 = "0dpx15001ha9p8h8vfg1lm9pggbc96kmb546hz88wdac5xycgqrh";
})
