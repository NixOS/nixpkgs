{ stdenv, fetchurl
, alsaLib, gstreamer, gstPluginsBase, pulseaudio
, libXft, libXrender, randrproto, xextproto, libXinerama, xineramaproto, libXcursor, libXmu
, libXv, libXext, libXfixes, inputproto, fixesproto, libXrandr, freetype, fontconfig
, zlib, libjpeg, libpng, libmng, which, mesa, openssl, dbus, cups, pkgconfig, libtiff, glib
, mysql, postgresql, sqlite
, perl, coreutils, libXi
, buildDemos ? false, buildExamples ? false, useDocs ? true}:

let
  v = "4.7.0-beta2";
in

stdenv.mkDerivation rec {
  name = "qt-${v}";

  src = fetchurl {
    url = "ftp://ftp.qt.nokia.com/qt/source/qt-everywhere-opensource-src-${v}.tar.gz";
    sha256 = "1gxckb5pxybnj5413dxk7dm8hm945ymm4ppqwg14wfk83zhnw6g0";
  };

  preConfigure = ''
    export LD_LIBRARY_PATH="`pwd`/lib:$LD_LIBRARY_PATH"
    configureFlags+="
      -docdir $out/share/doc/${name}
      -plugindir $out/lib/qt4/plugins
      -importdir $out/lib/qt4/imports
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
    libmng
    mysql
    postgresql
    libpng
    which
    mesa
    libXmu
    libXv
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
    gstreamer
    gstPluginsBase
    pulseaudio
  ];

  buildInputs = [ perl ];

  # libQtNetwork will call libQtCore for it to dlopen openssl.
  NIX_LDFLAGS = "-rpath ${openssl}/lib";
  # Don't shrink the rpath, to keep ${openssl} in it.
  dontPatchELF = 1;
  
  prefixKey = "-prefix ";

  configureFlags = ''
    -v -no-separate-debug-info -release -fast -confirm-license -opensource
    -system-zlib -system-libpng -system-libjpeg -qt-gif -system-libmng
    -opengl -xrender -xrandr -xinerama -xcursor
    -plugin-sql-mysql -system-sqlite
    -qdbus -cups -glib -xfixes -dbus-linked
    -fontconfig -I${freetype}/include/freetype2
    -exceptions -xmlpatterns
    -multimedia -audio-backend
    -phonon -phonon-backend -svg
    -javascript-jit
    ${if buildDemos == true then "-make demos" else "-nomake demos"}
    ${if buildExamples == true then "-make examples" else "-nomake examples"}
    ${if useDocs then "-make docs" else "-nomake docs"}'';
    
  patchPhase = ''
    substituteInPlace configure --replace /bin/pwd pwd
    substituteInPlace src/corelib/global/global.pri --replace /bin/ls ${coreutils}/bin/ls
    sed -e 's@/usr@/FOO@' -i config.tests/*/*.test -i mkspecs/*/*.conf
  '';

  postInstall = if useDocs then "rm -rf $out/share/doc/${name}/{html,src}" else "";

  meta = {
    homepage = http://qt.nokia.com/products;
    description = "A cross-platform application framework for C++";
    license = "GPL/LGPL";
    maintainers = with stdenv.lib.maintainers; [ urkud sander ];
    platforms = stdenv.lib.platforms.mesaPlatforms;
    priority = 10;
  };
}
