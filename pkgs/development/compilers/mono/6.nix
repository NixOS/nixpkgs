{ callPackage, Foundation, libobjc }:

callPackage ./generic.nix ({
  inherit Foundation libobjc;
  version = "6.8.0.105";
  srcArchiveSuffix = "tar.xz";
  sha256 = "0y11c7w6r96laqckfxnk1ya42hx2c1nfqvdgbpmsk1iw9k29k1sp";
  enableParallelBuilding = true;
})
