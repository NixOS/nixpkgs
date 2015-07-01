{ stdenv, fetchurl, gmp }:

stdenv.mkDerivation rec {
  name = "isl-0.14";

  src = fetchurl {
    url = "http://isl.gforge.inria.fr/${name}.tar.bz2";
    sha256 = "0dlg4b85nw4w534525h0fvb7yhb8i4am8kskhmm0ym7qabzh4g3y";
  };

  buildInputs = [ gmp ];

  enableParallelBuilding = true;

  doCheck = true;

  meta = {
    homepage = http://www.kotnet.org/~skimo/isl/;
    license = stdenv.lib.licenses.lgpl21;
    description = "A library for manipulating sets and relations of integer points bounded by linear constraints";
    platforms = stdenv.lib.platforms.all;
  };
}
