{ lib, stdenv, fetchFromGitHub, cmake, zlib, libpng }:

stdenv.mkDerivation rec {
  pname = "libharu";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "libharu";
    repo = pname;
    rev = "RELEASE_${lib.replaceStrings ["."] ["_"] version}";
    sha256 = "15s9hswnl3qqi7yh29jyrg0hma2n99haxznvcywmsp8kjqlyg75q";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ zlib libpng ];

  meta = {
    description = "Cross platform, open source library for generating PDF files";
    homepage = "http://libharu.org/";
    license = lib.licenses.zlib;
    maintainers = [ lib.maintainers.marcweber ];
    platforms = lib.platforms.unix;
  };
}
