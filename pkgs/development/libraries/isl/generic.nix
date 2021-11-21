{ version
, urls
, sha256
, configureFlags ? []
}:

{ lib, stdenv, fetchurl, gmp
}:

stdenv.mkDerivation {
  name = "isl-${version}";

  src = fetchurl {
    inherit urls sha256;
  };

  buildInputs = [ gmp ];

  inherit configureFlags;

  enableParallelBuilding = true;

  meta = {
    homepage = "https://libisl.sourceforge.io/";
    license = lib.licenses.lgpl21;
    description = "A library for manipulating sets and relations of integer points bounded by linear constraints";
    platforms = lib.platforms.all;
  };
}
