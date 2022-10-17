{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, dav1d, rav1e, libde265, x265, libpng,
  libjpeg, libaom }:

stdenv.mkDerivation rec {
  pname = "libheif";
  version = "1.13.0";

  outputs = [ "bin" "out" "dev" "man" ];

  src = fetchFromGitHub {
    owner = "strukturag";
    repo = "libheif";
    rev = "v${version}";
    sha256 = "sha256-/w/I6dgyiAscUqVpPjw2z6LbZJ6IBTeE5lawLg0awTM=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ dav1d rav1e libde265 x265 libpng libjpeg libaom ];

  enableParallelBuilding = true;

  meta = {
    homepage = "http://www.libheif.org/";
    description = "ISO/IEC 23008-12:2017 HEIF image file format decoder and encoder";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ gebner ];
  };
}
