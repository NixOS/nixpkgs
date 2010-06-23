{ stdenv, fetchurl, lib
, libXft, libXrender, randrproto, xextproto, libXinerama, xineramaproto, libXcursor, libXmu
, libXext, libXfixes, inputproto, fixesproto, libXrandr, freetype, fontconfig
, zlib, libjpeg, libpng, which, mesa, openssl, dbus, cups, pkgconfig, libtiff, glib
, mysql, postgresql
, perl, coreutils, libXi, sqlite, alsaLib
, buildDemos ? false, buildExamples ? false, useDocs ? true}:

stdenv.mkDerivation rec {
  name = "qt-4.6.3";
  
  src = fetchurl {
    url = ftp://ftp.qt.nokia.com/qt/source/qt-everywhere-opensource-src-4.6.3.tar.gz;
    sha256 = "f4e0ada8d4d516bbb8600a3ee7d9046c9c79e38cd781df9ffc46d8f16acd1768";
  };
  
  preConfigure = '' 
    export LD_LIBRARY_PATH="`pwd`/lib:$LD_LIBRARY_PATH"
    configureFlags+="
      -docdir $out/share/doc/${name}
      -plugindir $out/lib/qt4/plugins
      -examplesdir $out/share/doc/${name}/examples
      -demosdir $out/share/doc/${name}/demos
      -datadir $out/share/qt4
    "
  '';
  
  propagatedBuildInputs = [
    alsaLib
    sqlite
    libXft 
    libXrender 
    libXrandr 
    libXi
    randrproto 
    xextproto
    libXinerama 
    xineramaproto 
    libXcursor 
    zlib 
    libjpeg 
    mysql 
    postgresql
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

  buildInputs = [ perl ];

  # libQtNetwork will call libQtCore for it to dlopen openssl.
  NIX_LDFLAGS = "-rpath ${openssl}/lib";
  # Don't shrink the rpath, to keep ${openssl} in it.
  dontPatchELF = 1;
  
  prefixKey = "-prefix ";

  configureFlags = ''
    -v -no-separate-debug-info -release
    -system-zlib -system-libpng -system-libjpeg -fast
    -qt-gif -confirm-license -opensource
    -opengl -xrender -xrandr -xinerama -xcursor -qt-sql-mysql -system-sqlite
    -qdbus -cups -glib -xfixes -dbus-linked
    -fontconfig -I${freetype}/include/freetype2
    -exceptions -xmlpatterns
    ${if buildDemos == true then "" else "-nomake demos"}
    ${if buildExamples == true then "" else "-nomake examples"}
    ${if useDocs then "" else "-nomake docs"}
  '';
    
  patchPhase = ''
    substituteInPlace configure --replace /bin/pwd pwd
    substituteInPlace src/corelib/global/global.pri --replace /bin/ls ${coreutils}/bin/ls
    sed -e 's@/usr@/FOO@' -i config.tests/*/*.test -i mkspecs/*/*.conf
  '';

  postInstall = if useDocs then "rm -rf $out/share/doc/${name}/{html,src}" else "";

  enableParallelBuilding = true;

  meta = {
    homepage = http://qt.nokia.com/products;
    description = "A cross-platform application framework for C++";
    license = "GPL/LGPL";
    maintainers = with lib.maintainers; [ sander urkud ];
  };
}
