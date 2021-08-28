{ lib, stdenv, fetchurl, gmp }:

stdenv.mkDerivation rec {
  name = "isl-0.20";

  src = fetchurl {
    url = "http://isl.gforge.inria.fr/${name}.tar.xz";
    sha256 = "1akpgq0rbqbah5517blg2zlnfvjxfcl9cjrfc75nbcx5p2gnlnd5";
  };

  buildInputs = [ gmp ];

  configureFlags = [
    "--with-gcc-arch=generic" # don't guess -march=/mtune=
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "http://isl.gforge.inria.fr/";
    license = lib.licenses.lgpl21;
    description = "A library for manipulating sets and relations of integer points bounded by linear constraints";
    platforms = lib.platforms.all;
  };
}
