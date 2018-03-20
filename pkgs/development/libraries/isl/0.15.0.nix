{ stdenv, fetchurl, gmp }:

stdenv.mkDerivation rec {
  name = "isl-0.19";

  src = fetchurl {
    url = "http://isl.gforge.inria.fr/${name}.tar.xz";
    sha256 = "19dqyvngwj51fw2nfshr3r2hrbwkpsfrlvd4kx8gqv9a1sh1lv3d";
  };

  buildInputs = [ gmp ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://www.kotnet.org/~skimo/isl/;
    license = stdenv.lib.licenses.lgpl21;
    description = "A library for manipulating sets and relations of integer points bounded by linear constraints";
    platforms = stdenv.lib.platforms.all;
  };
}
