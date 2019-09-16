{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libde265, x265, libpng, libjpeg }:

stdenv.mkDerivation rec {
  pname = "libheif";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "strukturag";
    repo = "libheif";
    rev = "v${version}";
    sha256 = "1nvfjmnha06689imm8v24nlc011814gc9xq3x54cnmqvh5gn98ah";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libde265 x265 libpng libjpeg ];

  enableParallelBuilding = true;

  meta = {
    homepage = "http://www.libheif.org/";
    description = "ISO/IEC 23008-12:2017 HEIF image file format decoder and encoder";
    license = stdenv.lib.licenses.lgpl3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ gebner ];
  };

}
