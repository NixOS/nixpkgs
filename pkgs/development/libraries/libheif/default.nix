{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, libde265, x265, libpng,
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

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ libde265 x265 libpng libjpeg libaom ];
  # TODO: enable dav1d and rav1e codecs when libheif can find them via pkg-config

  enableParallelBuilding = true;

  meta = {
    homepage = "http://www.libheif.org/";
    description = "ISO/IEC 23008-12:2017 HEIF image file format decoder and encoder";
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ gebner ];
  };

}
