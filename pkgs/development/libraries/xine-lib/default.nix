{ stdenv, fetchurl, pkgconfig, xlibs, alsaLib, mesa, aalib
, libvorbis, libtheora, speex, zlib, libdvdcss, perl, ffmpeg
}:

stdenv.mkDerivation rec {
  name = "xine-lib-1.1.19";
  
  src = fetchurl {
    url = "mirror://sourceforge/xine/${name}.tar.bz2";
    sha256 = "0x47kmsaxx1bv8w2cacvzls3sjw9y4vk82rd94km1m1s6k2wcxv2";
  };
  
  buildInputs =
    [ xlibs.xlibs pkgconfig xlibs.libXv xlibs.libXinerama alsaLib mesa aalib
      libvorbis libtheora speex perl ffmpeg
      # removed SDL dependency; it's a big dependency and doesn't seem
      # particularly useful here.
    ];
    
  NIX_LDFLAGS = "-rpath ${libdvdcss}/lib -L${libdvdcss}/lib -ldvdcss";
  
  propagatedBuildInputs = [zlib];

  meta = {
    homepage = http://www.xine-project.org/;
    description = "A high-performance, portable and reusable multimedia playback engine";
  };
}
