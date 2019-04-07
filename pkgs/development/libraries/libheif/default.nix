{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libde265, x265, libpng, libjpeg }:

stdenv.mkDerivation rec {
  version = "1.4.0";
  name = "libheif-${version}";

  src = fetchFromGitHub {
    owner = "strukturag";
    repo = "libheif";
    rev = "v${version}";
    sha256 = "0vbjknkb2ccmw3xh2j8ljz5sj9i8wv92iw7zghcc5wn64sk1xkk2";
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
