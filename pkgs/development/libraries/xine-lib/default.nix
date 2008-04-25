args: with args;

(stdenv.mkDerivation rec {
  name = "xine-lib-1.1.12";
  src = fetchurl {
    url = "mirror://sourceforge/xine/${name}.tar.bz2";
    sha256 = "49088635c29a38527bd8590139691951783c5c1c7fdb691a8a3a9954097d4dd0";
  };
  buildInputs = [ x11 pkgconfig libXv libXinerama alsaLib mesa aalib SDL
  libvorbis libtheora speex ];
  configureFlags = "--with-xv-path=${libXv}/lib";
  NIX_LDFLAGS = "-rpath ${libdvdcss}/lib -L${libdvdcss}/lib -ldvdcss";
  propagatedBuildInputs = [zlib];
}) // { xineramaSupport = true; inherit libXinerama; }
