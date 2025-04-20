{
  callPackage,
  libobjc,
}:

callPackage ./generic.nix {
  inherit libobjc;
  version = "6.12.0.182";
  srcArchiveSuffix = "tar.xz";
  sha256 = "sha256-VzZqarTztezxEdSFSAMWFbOhANuHxnn8AG6Mik79lCQ=";
  enableParallelBuilding = true;
}
