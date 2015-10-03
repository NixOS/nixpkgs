{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "6.5.19";
  sha256 = "1x9zdmk8z784d3d35vr2ak1l4h5v4jfjhpxfi9fl9dvjkcavqyaj";
})
