{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libde265, x265, libpng, libjpeg }:

stdenv.mkDerivation rec {
  version = "1.5.0";
  pname = "libheif";

  src = fetchFromGitHub {
    owner = "strukturag";
    repo = pname;
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
