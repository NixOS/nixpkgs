{ stdenv, fetchurl
, xftSupport ? true, libXft ? null
, xrenderSupport ? true, libXrender ? null
, xrandrSupport ? true, libXrandr ? null, randrproto ? null
, xineramaSupport ? true, libXinerama ? null
, cursorSupport ? true, libXcursor ? null
, threadSupport ? true
, mysqlSupport ? false, mysql ? null
, openglSupport ? false, mesa ? null, libXmu ? null
, xlibsWrapper, xextproto, zlib, libjpeg, libpng, which
}:

assert xftSupport -> libXft != null;
assert xrenderSupport -> xftSupport && libXrender != null;
assert xrandrSupport -> libXrandr != null && randrproto != null;
assert cursorSupport -> libXcursor != null;
assert mysqlSupport -> mysql != null;
assert openglSupport -> mesa != null && libXmu != null;

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

  configureFlags = "
    -v
    -system-zlib -system-libpng -system-libjpeg
    -qt-gif
    -I${xextproto}/include
    ${if openglSupport then "-dlopen-opengl
      -L${mesa}/lib -I${mesa}/include
      -L${libXmu.out}/lib -I${libXmu.dev}/include" else ""}
    ${if threadSupport then "-thread" else "-no-thread"}
    ${if xrenderSupport then "-xrender -L${libXrender.out}/lib -I${libXrender.dev}/include" else "-no-xrender"}
    ${if xrandrSupport then "-xrandr
      -L${libXrandr.out}/lib -I${libXrandr.dev}/include
      -I${randrproto}/include" else "-no-xrandr"}
    ${if xineramaSupport then "-xinerama -L${libXinerama.out}/lib -I${libXinerama.dev}/include" else "-no-xinerama"}
    ${if cursorSupport then "-L${libXcursor.out}/lib -I${libXcursor.dev}/include" else ""}
    ${if mysqlSupport then "-qt-sql-mysql -L${stdenv.lib.getLib mysql.client}/lib/mysql -I${mysql.client}/include/mysql" else ""}
    ${if xftSupport then "-xft
      -L${libXft.out}/lib -I${libXft.dev}/include
      -L${libXft.freetype.out}/lib -I${libXft.freetype.dev}/include
      -L${libXft.fontconfig.lib}/lib -I${libXft.fontconfig.dev}/include" else "-no-xft"}
  ";

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
