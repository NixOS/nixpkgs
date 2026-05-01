{
  lib,
  aalib,
  alsa-lib,
  autoreconfHook,
  fetchhg,
  ffmpeg,
  flac,
  libGL,
  libGLU,
  libX11,
  libXext,
  libXinerama,
  libXv,
  libcaca,
  libcdio,
  libmng,
  libmpcdec,
  libpulseaudio,
  libtheora,
  libv4l,
  libvorbis,
  libxcb,
  ncurses,
  perl,
  pkg-config,
  speex,
  stdenv,
  vcdimager,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xine-lib";
  version = "1.2.13-unstable-2025-11-03";

  src = fetchhg {
    url = "http://hg.code.sf.net/p/xine/xine-lib-1.2";
    rev = "405a16a848927ed9861d6ac177c7e9624ecf58d1";
    hash = "sha256-Q+PcpVMgV2b+htEhTlUK63ZpuJ9Vz+dlmBhNiO8PC2A=";
  };

  outputs = [
    "out"
    "dev"
    "man"
  ];

  nativeBuildInputs = [
    autoreconfHook
    perl
    pkg-config
  ];

  buildInputs = [
    aalib
    alsa-lib
    ffmpeg
    flac
    libGL
    libGLU
    libX11
    libX11
    libXext
    libXext
    libXinerama
    libXinerama
    libXv
    libXv
    libcaca
    libcdio
    libmng
    libmpcdec
    libpulseaudio
    libtheora
    libv4l
    libvorbis
    libxcb
    libxcb
    ncurses
    perl
    speex
    vcdimager
    zlib
  ];

  env.NIX_LDFLAGS = "-lxcb-shm";

  enableParallelBuilding = true;

  strictDeps = true;

  meta = {
    homepage = "https://xine.sourceforge.net/";
    description = "High-performance, portable and reusable multimedia playback engine";
    license = with lib.licenses; [
      gpl2Plus
      lgpl2Plus
    ];
    # No useful mainProgram
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
