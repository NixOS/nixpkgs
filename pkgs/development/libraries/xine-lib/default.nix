{ stdenv, fetchurl, fetchpatch, pkgconfig, xorg, alsaLib, libGLU, libGL, aalib
, libvorbis, libtheora, speex, zlib, perl, ffmpeg_3
, flac, libcaca, libpulseaudio, libmng, libcdio, libv4l, vcdimager
, libmpcdec
}:

stdenv.mkDerivation rec {
  name = "xine-lib-1.2.9";

  src = fetchurl {
    url = "mirror://sourceforge/xine/${name}.tar.xz";
    sha256 = "13clir4qxl2zvsvvjd9yv3yrdhsnvcn5s7ambbbn5dzy9604xcrj";
  };

  nativeBuildInputs = [ pkgconfig perl ];

  buildInputs = [
    xorg.libX11 xorg.libXv xorg.libXinerama xorg.libxcb xorg.libXext
    alsaLib libGLU libGL aalib libvorbis libtheora speex perl ffmpeg_3 flac
    libcaca libpulseaudio libmng libcdio libv4l vcdimager libmpcdec
  ];

  patches = [
    (fetchpatch {
      name = "0001-fix-XINE_PLUGIN_PATH-splitting.patch";
      url = "https://sourceforge.net/p/xine/mailman/attachment/32394053-5e27-6558-f0c9-49e0da0bc3cc%40gmx.de/1/";
      sha256 = "0nrsdn7myvjs8fl9rj6k4g1bnv0a84prsscg1q9n49gwn339v5rc";
    })
  ];

  NIX_LDFLAGS = "-lxcb-shm";

  propagatedBuildInputs = [zlib];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "http://www.xine-project.org/";
    description = "A high-performance, portable and reusable multimedia playback engine";
    platforms = platforms.linux;
    license = with licenses; [ gpl2 lgpl2 ];
  };
}
