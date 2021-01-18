{ callPackage, Foundation, libobjc }:

callPackage ./generic.nix ({
  inherit Foundation libobjc;
  version = "6.12.0.90";
  srcArchiveSuffix = "tar.xz";
  sha256 = "1b6d0926rd0nkmsppwjgmwsxx1479jjvr1gm7zwk64siml15rpji";
  enableParallelBuilding = true;
})
