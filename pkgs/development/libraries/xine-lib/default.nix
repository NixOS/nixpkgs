{ lib
, stdenv
, fetchurl
, aalib
, alsa-lib
, ffmpeg
, flac
, libGL
, libGLU
, libcaca
, libcdio
, libmng
, libmpcdec
, libpulseaudio
, libtheora
, libv4l
, libvorbis
, ncurses
, perl
, pkg-config
, speex
, vcdimager
, xorg
, zlib
}:

stdenv.mkDerivation rec {
  pname = "xine-lib";
  version = "1.2.11";

  src = fetchurl {
    url = "mirror://sourceforge/xine/xine-lib-${version}.tar.xz";
    sha256 = "sha256-71GyHRDdoQRfp9cRvZFxz9rwpaKHQjO88W/98o7AcAU=";
  };

  nativeBuildInputs = [
    pkg-config
    perl
  ];
  buildInputs = [
    aalib
    alsa-lib
    ffmpeg
    flac
    libGL
    libGLU
    libcaca
    libcdio
    libmng
    libmpcdec
    libpulseaudio
    libtheora
    libv4l
    libvorbis
    ncurses
    perl
    speex
    vcdimager
    zlib
  ] ++ (with xorg; [
    libX11
    libXext
    libXinerama
    libXv
    libxcb
  ]);

  enableParallelBuilding = true;

  NIX_LDFLAGS = "-lxcb-shm";


  meta = with lib; {
    homepage = "http://www.xinehq.de/";
    description = "A high-performance, portable and reusable multimedia playback engine";
    license = with licenses; [ gpl2Plus lgpl2Plus ];
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.linux;
  };
}
