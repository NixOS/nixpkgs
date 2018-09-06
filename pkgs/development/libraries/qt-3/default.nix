{ stdenv, fetchurl
, xftSupport ? true, libXft ? null
, xrenderSupport ? true, libXrender ? null
, xrandrSupport ? true, libXrandr ? null, randrproto ? null
, xineramaSupport ? true, libXinerama ? null
, cursorSupport ? true, libXcursor ? null
, threadSupport ? true
, mysqlSupport ? false, mysql ? null
, openglSupport ? false, libGLU_combined ? null, libXmu ? null
, xlibsWrapper, xextproto, zlib, libjpeg, libpng, which
}:

assert xftSupport -> libXft != null;
assert xrenderSupport -> xftSupport && libXrender != null;
assert xrandrSupport -> libXrandr != null && randrproto != null;
assert cursorSupport -> libXcursor != null;
assert mysqlSupport -> mysql != null;
assert openglSupport -> libGLU_combined != null && libXmu != null;

stdenv.mkDerivation {
  name = "qt-3.3.8";

  builder = ./builder.sh;

  setupHook = ./setup-hook.sh;

  src = fetchurl {
    url = http://download.qt.io/archive/qt/3/qt-x11-free-3.3.8.tar.bz2;
    sha256 = "0jd4g3bwkgk2s4flbmgisyihm7cam964gzb3pawjlkhas01zghz8";
  };

  nativeBuildInputs = [ which ];
  propagatedBuildInputs = [libpng xlibsWrapper libXft libXrender zlib libjpeg];

  hardeningDisable = [ "format" ];

  configureFlags = let
    mk = cond: name: "-${stdenv.lib.optionalString (!cond) "no-"}${name}";
  in [
    "-v"
    "-system-zlib" "-system-libpng" "-system-libjpeg"
    "-qt-gif"
    "-I${xextproto}/include"
    (mk threadSupport "thread")
    (mk xrenderSupport "xrender")
    (mk xrandrSupport "xrandr")
    (mk xineramaSupport "xinerama")
    (mk xrandrSupport "xrandr")
    (mk xftSupport "xft")
  ] ++ stdenv.lib.optionals openglSupport [
    "-dlopen-opengl"
    "-L${libGLU_combined}/lib" "-I${libGLU_combined}/include"
    "-L${libXmu.out}/lib" "-I${libXmu.dev}/include"
  ] ++ stdenv.lib.optionals xrenderSupport [
    "-L${libXrender.out}/lib" "-I${libXrender.dev}/include"
  ] ++ stdenv.lib.optionals xrandrSupport [
    "-L${libXrandr.out}/lib" "-I${libXrandr.dev}/include"
    "-I${randrproto}/include"
  ] ++ stdenv.lib.optionals xineramaSupport [
    "-L${libXinerama.out}/lib" "-I${libXinerama.dev}/include"
  ] ++ stdenv.lib.optionals cursorSupport [
    "-L${libXcursor.out}/lib -I${libXcursor.dev}/include"
  ] ++ stdenv.lib.optionals mysqlSupport [
    "-qt-sql-mysql" "-L${mysql.connector-c}/lib/mysql" "-I${mysql.connector-c}/include/mysql"
  ] ++ stdenv.lib.optionals xftSupport [
    "-L${libXft.out}/lib" "-I${libXft.dev}/include"
    "-L${libXft.freetype.out}/lib" "-I${libXft.freetype.dev}/include"
    "-L${libXft.fontconfig.lib}/lib" "-I${libXft.fontconfig.dev}/include"
  ];

  patches = [
    # Don't strip everything so we can get useful backtraces.
    ./strip.patch

    # Build on NixOS.
    ./qt-pwd.patch

    # randr.h and Xrandr.h need not be in the same prefix.
    ./xrandr.patch

    # Make it build with gcc 4.6.0
    ./qt3-gcc4.6.0.patch
  ];

  passthru = {inherit mysqlSupport;};

  meta = {
    platforms = stdenv.lib.platforms.linux;
  };
}
