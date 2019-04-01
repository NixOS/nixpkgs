{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libde265, x265, libpng, libjpeg }:

stdenv.mkDerivation rec {
  version = "1.4.0";
  name = "libheif-${version}";

  src = fetchFromGitHub {
    owner = "strukturag";
    repo = "libheif";
    rev = "v${version}";
    sha256 = "977a9831f1d61b5005566945c7e16e31de35a57a8dd6eb715ae0f40a3595cb60";
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
