{stdenv, fetchurl, protobuf}:

stdenv.mkDerivation {
  name = "libosmpbf-1.4.0";

  src = fetchurl {
    url = "https://github.com/scrosby/OSM-binary/archive/v1.4.0.tar.gz";
    sha256 = "1bicphgj413m5q1gqlwzr1grfbdx8ixamq26g493rlhas5248qxy";
  };

  buildInputs = [ protobuf ];

  sourceRoot = "OSM-binary-1.4.0/src";

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "https://github.com/scrosby/OSM-binary";
    description = "C library to read and write OpenStreetMap PBF files";
    license = stdenv.lib.licenses.lgpl3;
    platforms = stdenv.lib.platforms.unix;
  };
}
