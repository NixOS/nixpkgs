{ lib, stdenv, fetchurl, pkg-config, xorg, alsaLib, libGLU, libGL, aalib
, libvorbis, libtheora, speex, zlib, perl, ffmpeg_3
, flac, libcaca, libpulseaudio, libmng, libcdio, libv4l, vcdimager
, libmpcdec, ncurses
}:

stdenv.mkDerivation rec {
  pname = "xine-lib";
  version = "1.2.11";

  src = fetchurl {
    url = "mirror://sourceforge/xine/xine-lib-${version}.tar.xz";
    sha256 = "01bhq27g5zbgy6y36hl7lajz1nngf68vs4fplxgh98fx20fv4lgg";
  };

  nativeBuildInputs = [ pkg-config perl ];

  buildInputs = [
    xorg.libX11 xorg.libXv xorg.libXinerama xorg.libxcb xorg.libXext
    alsaLib libGLU libGL aalib libvorbis libtheora speex perl ffmpeg_3 flac
    libcaca libpulseaudio libmng libcdio libv4l vcdimager libmpcdec ncurses
  ];

  NIX_LDFLAGS = "-lxcb-shm";

  propagatedBuildInputs = [zlib];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "http://xine.sourceforge.net/home";
    description = "A high-performance, portable and reusable multimedia playback engine";
    platforms = platforms.linux;
    license = with licenses; [ gpl2Plus lgpl2Plus ];
  };
}
