{ stdenv, fetchurl, lib
, libXft, libXrender, randrproto, xextproto, libXinerama, xineramaproto, libXcursor, libXmu
, libXext, libXfixes, inputproto, fixesproto, libXrandr, freetype, fontconfig
, zlib, libjpeg, mysql, libpng, which, mesa, openssl, dbus, cups, pkgconfig, libtiff, glib
, buildDemos ? false, buildExamples ? false, keepDocumentation ? false}:

stdenv.mkDerivation {
  name = "qt-4.6.2";
  
  src = fetchurl {
    url = ftp://ftp.qt.nokia.com/qt/source/qt-everywhere-opensource-src-4.6.2.tar.gz;
    sha256 = "1bpz59y907zz2p67mnf5ckvxh7n2glr6pz1f9fmngkkdn3fm2vqp";
  };
  
  setupHook = ./setup-hook.sh;

  preConfigure = '' 
    export LD_LIBRARY_PATH="`pwd`/lib:$LD_LIBRARY_PATH"
  '';
  
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

  # libQtNetwork will call libQtCore for it to dlopen openssl.
  NIX_LDFLAGS = "-rpath ${openssl}/lib";
  # Don't shrink the rpath, to keep ${openssl} in it.
  dontPatchELF = 1;
  
  prefixKey = "-prefix ";

  configureFlags = ''
    -v -no-separate-debug-info -release
    -system-zlib -system-libpng -system-libjpeg -fast
    -qt-gif -confirm-license -opensource
    -opengl -xrender -xrandr -xinerama -xcursor -qt-sql-mysql
    -qdbus -cups -glib -xfixes -dbus-linked
    -fontconfig -I${freetype}/include/freetype2
    ${if buildDemos == true then "" else "-nomake demos"}
    ${if buildExamples == true then "" else "-nomake examples"}
  '';
    
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
    license = "GPL/LGPL";
    maintainers = [ lib.maintainers.sander ];
  };
}
