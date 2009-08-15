{ stdenv, fetchurl
, libXft, libXrender, randrproto, xextproto, libXinerama, xineramaproto, libXcursor, libXmu
, libXext, libXfixes, inputproto, fixesproto, libXrandr, freetype, fontconfig
, zlib, libjpeg, mysql, libpng, which, mesa, openssl, dbus, cups, pkgconfig, libtiff, glib
, buildDemos ? false, buildExamples ? false, keepDocumentation ? false}:

stdenv.mkDerivation {
  name = "qt-4.5.2";
  
  src = fetchurl {
    url = ftp://ftp.trolltech.com/qt/source/qt-x11-opensource-src-4.5.2.tar.bz2;
    sha256 = "0dpq45viarklgyjzmmzrpdgrzv36gwawg6mk2dmf3pwhrg4r8vfj";
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
    -prefix $out
    -v -no-separate-debug-info -release
    -system-zlib -system-libpng -system-libjpeg -fast
    -qt-gif -confirm-license
    -opengl -xrender -xrandr -xinerama -xcursor -qt-sql-mysql
    -qdbus -cups -glib -xfixes -dbus-linked
    -fontconfig -I${freetype}/include/freetype2
    ${if buildDemos == true then "" else "-nomake demos"}
    ${if buildExamples == true then "" else "-nomake examples"}
  '';
    
  configurePhase = "echo o | ./configure $configureFlags";
  
  patchPhase = ''
    substituteInPlace configure --replace /bin/pwd pwd
    sed -e 's@/usr@/FOO@' -i config.tests/*/*.test -i mkspecs/*/*.conf
  '';

  # Remove the documentation: it takes up >= 130 MB, which is more
  # than half of the installed size.  Ideally we should put this in a
  # separate package (as well as the Qt Designer).
  postInstall = ''
    ${if keepDocumentation == false then "rm -rf $out/doc" else ""}
  '';

  meta = {
    homepage = http://www.qtsoftware.com/downloads/opensource/appdev/linux-x11-cpp;
    description = "A cross-platform application framework for C++";
  };
}
