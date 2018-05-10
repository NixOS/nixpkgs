{ stdenv, fetchurl, gmp }:

stdenv.mkDerivation rec {
  name = "isl-0.15";

  src = fetchurl {
    url = "http://isl.gforge.inria.fr/${name}.tar.xz";
    sha256 = "1m922l5bz69lvkcxrib7lvjqwfqsr8rpbzgmb2aq07bp76460jhh";
  };

  buildInputs = [ gmp ];

  enableParallelBuilding = true;

  meta = {
    homepage = https://www.kotnet.org/~skimo/isl/;
    license = stdenv.lib.licenses.lgpl21;
    description = "A library for manipulating sets and relations of integer points bounded by linear constraints";
    platforms = stdenv.lib.platforms.all;
  };
}
