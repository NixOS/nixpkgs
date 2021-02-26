{lib, stdenv, fetchurl, protobuf}:

stdenv.mkDerivation {
  name = "libosmpbf-1.5.0";

  src = fetchurl {
    url = "https://github.com/scrosby/OSM-binary/archive/v1.5.0.tar.gz";
    sha256 = "sha256-Kr8xJnKXk3MsM4B2OZnMNl5Rv/2jaaAIITh5o82QR2w=";
  };

  buildInputs = [ protobuf ];

  sourceRoot = "OSM-binary-1.5.0/src";

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "https://github.com/scrosby/OSM-binary";
    description = "C library to read and write OpenStreetMap PBF files";
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.unix;
  };
}
