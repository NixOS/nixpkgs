{ lib, stdenv, fetchFromGitHub, cmake, zlib, libpng }:

stdenv.mkDerivation rec {
  pname = "libharu";
  version = "2.4.3";

  src = fetchFromGitHub {
    owner = "libharu";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-v8eD1ZEFQFA7ceWOgOmq7hP0ZMPfxjdAp7ov4PBPaAE=";
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
