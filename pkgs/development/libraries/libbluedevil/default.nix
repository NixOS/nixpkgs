{ lib, stdenv, fetchurl, cmake, qt4 }:

stdenv.mkDerivation rec {
  pname = "libbluedevil";
  # bluedevil must have the same major version (x.y) as libbluedevil!
  # do not update this package without checking bluedevil
  version = "2.1";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/src/${pname}-${version}.tar.xz";
    sha256 = "0p4f0brhcz9gfxfd6114fa5x6swfdmgzv350xwncdr0s1qnamk8c";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ qt4 ];

  meta = {
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2Plus;
  };
}
