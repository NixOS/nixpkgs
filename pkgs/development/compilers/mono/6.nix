{ callPackage, Foundation, libobjc }:

callPackage ./generic.nix ({
  inherit Foundation libobjc;
  version = "6.12.0.122";
  srcArchiveSuffix = "tar.xz";
  sha256 = "sha256-KcJ3Zg/F51ExB67hy/jFBXyTcKTN/tovx4G+aYbYnSM=";
  enableParallelBuilding = true;
})
