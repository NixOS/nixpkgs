{ stdenv, fetchurl, pkgconfig, xorg, alsaLib, mesa, aalib
, libvorbis, libtheora, speex, zlib, libdvdcss, perl, ffmpeg
, flac, libcaca, pulseaudio, libmng, libcdio, libv4l, vcdimager
, libmpcdec
}:

stdenv.mkDerivation rec {
  name = "xine-lib-1.2.4";
  
  src = fetchurl {
    url = "mirror://sourceforge/xine/${name}.tar.xz";
    sha256 = "1pdv7bs683ily548arv4wsxabslyf3x3laij5jb921dxyx71nnww";
  };

  nativeBuildInputs = [ pkgconfig perl ];

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
