args: with args;

(stdenv.mkDerivation rec {
  name = "xine-lib-1.1.9.1";
  src = fetchurl {
    url = "mirror://sourceforge/xine/${name}.tar.bz2";
    sha256 = "1rz4k2a9pny2ksqb5diw1ci8ijihpcm0mi8qxp5p7nasgzgqcj82";
  };
  buildInputs = [ x11 pkgconfig libXv libXinerama alsaLib mesa aalib SDL
  libvorbis libtheora speex ];
  configureFlags = "--with-xv-path=${libXv}/lib";
  NIX_LDFLAGS = "-rpath ${libdvdcss}/lib -L${libdvdcss}/lib -ldvdcss";
  propagatedBuildInputs = [zlib];
}) // { xineramaSupport = true; inherit libXinerama; }
