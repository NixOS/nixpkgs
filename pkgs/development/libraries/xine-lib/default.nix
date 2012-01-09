{ stdenv, fetchurl, pkgconfig, xorg, alsaLib, mesa, aalib
, libvorbis, libtheora, speex, zlib, libdvdcss, perl, ffmpeg
, flac, libcaca, pulseaudio, libmng, libcdio, libv4l, vcdimager
, libmpcdec
}:

stdenv.mkDerivation rec {
  name = "xine-lib-1.2.0";
  
  src = fetchurl {
    url = "mirror://sourceforge/xine/${name}.tar.bz2";
    sha256 = "1yss9cxxkcb6dzrv78xvi845ls6lhhbv6g8yfm6zjjl07v7jbm6c";
  };

#  patches =
#    [ (fetchurl {
#        url = "http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/media-libs/xine-lib/files/xine-lib-1.1.19-ffmpeg.patch?revision=1.1";
#        sha256 = "0dqr0kc829djfn0wvk4jg84v61pxynqbp4s4phvywd7x9caf092b";
#      })
#    ];
  
  buildNativeInputs = [ pkgconfig perl ];

  buildInputs = [
    xorg.libX11 xorg.libXv xorg.libXinerama xorg.libxcb xorg.libXext
    alsaLib mesa aalib libvorbis libtheora speex perl ffmpeg flac
    libcaca pulseaudio libmng libcdio libv4l vcdimager libmpcdec
  ];

  NIX_LDFLAGS = "-rpath ${libdvdcss}/lib -L${libdvdcss}/lib -ldvdcss";
  
  propagatedBuildInputs = [zlib];

  enableParallelBuilding = true;

  meta = {
    homepage = http://www.xine-project.org/;
    description = "A high-performance, portable and reusable multimedia playback engine";
  };
}
