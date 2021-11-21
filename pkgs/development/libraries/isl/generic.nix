{ lib, stdenv, fetchurl, gmp
, version
, urls
, sha256
}:

stdenv.mkDerivation rec {
  pname = "isl";
  inherit version;

  src = fetchurl {
    inherit urls sha256;
  };

  buildInputs = [ gmp ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://libisl.sourceforge.io/";
    license = lib.licenses.lgpl21;
    description = "A library for manipulating sets and relations of integer points bounded by linear constraints";
    platforms = lib.platforms.all;
  };
}
