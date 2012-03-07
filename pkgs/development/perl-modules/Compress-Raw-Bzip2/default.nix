{ fetchurl, buildPerlPackage, bzip2 }:

buildPerlPackage rec {
  name = "Compress-Raw-Bzip2-2.049";

  src = fetchurl {
    url = "mirror://cpan/modules/by-module/Compress/${name}.tar.gz";
    sha256 = "7881473e0ab5ecc6ce609382e4f7466fb32217e928eef27e7084702bb07ac172";
  };

  # Don't build a private copy of bzip2.
  BUILD_BZIP2 = false;
  BZIP2_LIB = "${bzip2}/lib";
  BZIP2_INCLUDE = "${bzip2}/include";
}
