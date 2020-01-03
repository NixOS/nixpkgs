{ callPackage, Foundation, libobjc }:

callPackage ./generic.nix ({
  inherit Foundation libobjc;
  version = "6.0.0.313";
  srcArchiveSuffix = "tar.xz";
  sha256 = "0l0cd6q5xh1vdm6zr78rkfqdsmrgzanjgpxvgig0pyd3glfyjim9";
  enableParallelBuilding = true;
})
