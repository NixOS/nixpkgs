args: with args;
stdenv.mkDerivation {
  name = "qt-4.4.0";
  
  src = fetchurl {
    url = ftp://ftp.trolltech.com/qt/source/qt-x11-opensource-src-4.4.0.tar.bz2;
    sha256 = "871dc71c6c905212f2fea7e6598362114a3b6097c220b0b251f8d159ee7d706e";
  };
  
  setupHook = ./setup-hook.sh;  
  propagatedBuildInputs = [
    libXft 
    libXrender 
    libXrandr 
    randrproto 
    xextproto
    libXinerama 
    xineramaproto 
    libXcursor 
    zlib 
    libjpeg 
    mysql 
    libpng 
    which 
    mesa
    libXmu 
    openssl 
    dbus.libs 
    cups 
    pkgconfig 
    libXext 
    freetype 
    fontconfig 
    inputproto
    fixesproto 
    libXfixes 
    glib 
    libtiff
  ];
  prefixKey = "-prefix ";
  configureFlags = "
    -v -no-separate-debug-info -release
    -system-zlib -system-libpng -system-libjpeg -fast
    -qt-gif -confirm-license
    -opengl -xrender -xrandr -xinerama -xcursor -qt-sql-mysql
    -qdbus -cups -glib -xfixes
    -fontconfig -I${freetype}/include/freetype2";

  patchPhase = "sed -e 's@/bin/pwd@pwd@' -i configure; sed -e 's@/usr@/FOO@' -i config.tests/*/*.test -i mkspecs/*/*.conf";
}
