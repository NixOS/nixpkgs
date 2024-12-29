{ lib
, stdenv
, fetchurl
, autoreconfHook
, pkg-config
, fftw
, withFftw3 ? (!stdenv.hostPlatform.isMinGW)
}:

stdenv.mkDerivation rec {
  pname = "speexdsp";
  version = "1.2.1";

  src = fetchurl {
    url = "https://downloads.xiph.org/releases/speex/${pname}-${version}.tar.gz";
    sha256 = "sha256-jHdzQ+SmOZVpxyq8OKlbJNtWiCyD29tsZCSl9K61TT0=";
  };

  patches = [ ./build-fix.patch ];
  postPatch = "sed '3i#include <stdint.h>' -i ./include/speex/speexdsp_config_types.h.in";

  outputs = [ "out" "dev" "doc" ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = lib.optionals withFftw3 [ fftw ];

  configureFlags = lib.optionals withFftw3 [ "--with-fft=gpl-fftw3" ]
    ++ lib.optional stdenv.isAarch64 "--disable-neon";

  meta = with lib; {
    homepage = "https://www.speex.org/";
    description = "Open Source/Free Software patent-free audio compression format designed for speech";
    license = licenses.bsd3;
    platforms = platforms.unix ++ platforms.windows;
  };
}
