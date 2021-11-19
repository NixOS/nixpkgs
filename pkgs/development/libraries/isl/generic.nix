{ lib, stdenv, fetchurl, gmp
, version
, urls
, sha256
, homepage }:

stdenv.mkDerivation rec {
  pname = "isl";
  inherit version;

  src = fetchurl {
    inherit urls sha256;
  };

  buildInputs = [ gmp ];

  enableParallelBuilding = true;

  meta = {
    inherit homepage;
    license = lib.licenses.lgpl21;
    description = "A library for manipulating sets and relations of integer points bounded by linear constraints";
    platforms = lib.platforms.all;
  };
}
