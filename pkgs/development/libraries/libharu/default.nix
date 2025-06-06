{ lib, stdenv, fetchFromGitHub, cmake, zlib, libpng }:

stdenv.mkDerivation rec {
  pname = "libharu";
  version = "2.4.4";

  src = fetchFromGitHub {
    owner = "libharu";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-tw/E79Cg/8kIei6NUu1W+mP0sUDCm8KTB7ZjzxsqpeM=";
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
