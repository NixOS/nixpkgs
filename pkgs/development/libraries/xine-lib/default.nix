{ stdenv, fetchurl, pkgconfig, xorg, alsaLib, libGLU_combined, aalib
, libvorbis, libtheora, speex, zlib, libdvdcss, perl, ffmpeg
, flac, libcaca, libpulseaudio, libmng, libcdio, libv4l, vcdimager
, libmpcdec
}:

stdenv.mkDerivation rec {
  name = "xine-lib-1.2.6";

  src = fetchurl {
    url = "mirror://sourceforge/xine/${name}.tar.xz";
    sha256 = "01d0nv4zhr4k8id5n4rmw13llrjsv9dhwg1a773c1iqpi1ris15x";
  };

  nativeBuildInputs = [ pkgconfig perl ];

  buildInputs = [
    xorg.libX11 xorg.libXv xorg.libXinerama xorg.libxcb xorg.libXext
    alsaLib libGLU_combined aalib libvorbis libtheora speex perl ffmpeg flac
    libcaca libpulseaudio libmng libcdio libv4l vcdimager libmpcdec
  ];

  NIX_LDFLAGS = "-lxcb-shm";

  propagatedBuildInputs = [zlib];

  enableParallelBuilding = true;

  meta = {
    homepage = http://www.xine-project.org/;
    description = "A high-performance, portable and reusable multimedia playback engine";
    platforms = stdenv.lib.platforms.linux;
  };
}
