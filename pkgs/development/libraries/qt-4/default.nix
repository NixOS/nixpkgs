args: with args;

stdenv.mkDerivation {
  name = "qt-4.4.3";
  
  src = fetchurl {
    url = ftp://ftp.trolltech.com/qt/source/qt-x11-opensource-src-4.4.3.tar.bz2;
    sha256 = "1nfdf1aj6vb7qyacsnjyjxrnaf44hz7vzykf6zra2znd87pglz51";
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
  
  configureFlags = ''
    -v -no-separate-debug-info -release
    -system-zlib -system-libpng -system-libjpeg -fast
    -qt-gif -confirm-license
    -opengl -xrender -xrandr -xinerama -xcursor -qt-sql-mysql
    -qdbus -cups -glib -xfixes
    -fontconfig -I${freetype}/include/freetype2
  '';

  patchPhase = ''
    substituteInPlace configure --replace /bin/pwd pwd
    sed -e 's@/usr@/FOO@' -i config.tests/*/*.test -i mkspecs/*/*.conf
  '';

  meta = {
    homepage = http://www.qtsoftware.com/downloads/opensource/appdev/linux-x11-cpp;
    description = "A cross-platform application framework for C++";
  };
}
