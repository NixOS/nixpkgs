{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, dav1d, rav1e, libde265, x265, libpng,
  libjpeg, libaom }:

stdenv.mkDerivation rec {
  pname = "libheif";
  version = "1.12.0";

  outputs = [ "bin" "out" "dev" "man" ];

  src = fetchFromGitHub {
    owner = "strukturag";
    repo = "libheif";
    rev = "v${version}";
    sha256 = "sha256-RjGLaDSBO8T7ijRb5a16aUlkCy5vdFPs4O9caIJo4jI=";
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
