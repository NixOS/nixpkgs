{ stdenv, fetchurl, gmp }:

stdenv.mkDerivation rec {
  name = "isl-0.12.2"; # CLooG 0.16.3 fails to build with ISL 0.08.

  src = fetchurl {
    url = "http://isl.gforge.inria.fr/${name}.tar.bz2";
    sha256 = "1d0zs64yw6fzs6b7kxq6nh9kvas16h8b43agwh30118jjzpdpczl";
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
