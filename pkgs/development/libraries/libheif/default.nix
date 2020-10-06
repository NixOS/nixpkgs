{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libde265, x265, libpng,
  libjpeg, libaom }:

stdenv.mkDerivation rec {
  pname = "libheif";
  version = "1.9.1";

  outputs = [ "bin" "out" "dev" "man" ];

  src = fetchFromGitHub {
    owner = "strukturag";
    repo = "libheif";
    rev = "v${version}";
    sha256 = "0hjs1i076jmy4ryj8y2zs293wx53kzg38y8i42cbcsqydvsdp6hz";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libde265 x265 libpng libjpeg libaom ];
  # TODO: enable dav1d and rav1e codecs when libheif can find them via pkg-config

  enableParallelBuilding = true;

  meta = {
    homepage = "http://www.libheif.org/";
    description = "ISO/IEC 23008-12:2017 HEIF image file format decoder and encoder";
    license = stdenv.lib.licenses.lgpl3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ gebner ];
  };

}
