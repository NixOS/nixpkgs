{stdenv, fetchurl, protobuf}:

stdenv.mkDerivation rec {
  name = "libosmpbf-1.3.3";

  src = fetchurl {
    url = "https://github.com/scrosby/OSM-binary/archive/v1.3.3.tar.gz";
    sha256 = "a109f338ce6a8438a8faae4627cd08599d0403b8977c185499de5c17b92d0798";
  };

  buildInputs = [ protobuf ];

  sourceRoot = "OSM-binary-1.3.3/src";

  installFlags = "PREFIX=$(out)";

  meta = {
    homepage = https://github.com/scrosby/OSM-binary;
    description = "C library to read and write OpenStreetMap PBF files";
    license = stdenv.lib.licenses.lgpl3;
    platforms = stdenv.lib.platforms.unix;
  };
}
