{ stdenv, fetchurl, cmake, qt4 }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "libbluedevil";
  # bluedevil must have the same major version (x.y) as libbluedevil!
  # do not update this package without checking bluedevil
  version = "2.1";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/src/${name}.tar.xz";
    sha256 = "0p4f0brhcz9gfxfd6114fa5x6swfdmgzv350xwncdr0s1qnamk8c";
  };

  buildInputs = [ cmake qt4 ];

  meta = {
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
