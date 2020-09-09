{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libde265, x265, libpng, libjpeg }:

stdenv.mkDerivation rec {
  pname = "libheif";
  version = "1.7.0";

  outputs = [ "bin" "out" "dev" "man" ];

  src = fetchFromGitHub {
    owner = "strukturag";
    repo = "libheif";
    rev = "v${version}";
    sha256 = "0alri5h486ck9b5z6wwrmlpzydhz58l223z3zxkizqrzxlllhr6p";
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
