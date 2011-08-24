{ stdenv, fetchurl, pkgconfig, xorg, alsaLib, mesa, aalib
, libvorbis, libtheora, speex, zlib, libdvdcss, perl, ffmpeg
, flac, libcaca, pulseaudio, libmng
}:

stdenv.mkDerivation rec {
  name = "xine-lib-1.1.19";
  
  src = fetchurl {
    url = "mirror://sourceforge/xine/${name}.tar.bz2";
    sha256 = "0x47kmsaxx1bv8w2cacvzls3sjw9y4vk82rd94km1m1s6k2wcxv2";
  };

  patches =
    [ (fetchurl {
        url = "http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/media-libs/xine-lib/files/xine-lib-1.1.19-ffmpeg.patch?revision=1.1";
        sha256 = "0dqr0kc829djfn0wvk4jg84v61pxynqbp4s4phvywd7x9caf092b";
      })
    ];
  
  buildNativeInputs = [ pkgconfig perl ];

  buildInputs = [
    xorg.libX11 xorg.libXv xorg.libXinerama xorg.libxcb xorg.libXext
    alsaLib mesa aalib libvorbis libtheora speex perl ffmpeg flac
    libcaca pulseaudio libmng
  ];

  NIX_LDFLAGS = "-rpath ${libdvdcss}/lib -L${libdvdcss}/lib -ldvdcss";
  
  propagatedBuildInputs = [zlib];

  enableParallelBuilding = true;

  meta = {
    homepage = http://www.xine-project.org/;
    description = "A high-performance, portable and reusable multimedia playback engine";
  };
}
