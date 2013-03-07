{ stdenv, fetchurl
, xftSupport ? true, libXft ? null
, xrenderSupport ? true, libXrender ? null
, xrandrSupport ? true, libXrandr ? null, randrproto ? null
, xineramaSupport ? true, libXinerama ? null
, cursorSupport ? true, libXcursor ? null
, threadSupport ? true
, mysqlSupport ? false, mysql ? null
, openglSupport ? false, mesa ? null, libXmu ? null
, x11, xextproto, zlib, libjpeg, libpng12, which
}:

let libpng = libpng12; in

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
    url = ftp://ftp.trolltech.com/qt/source/qt-x11-free-3.3.8.tar.bz2;
    sha256 = "0jd4g3bwkgk2s4flbmgisyihm7cam964gzb3pawjlkhas01zghz8";
  };

  nativeBuildInputs = [ which ];
  propagatedBuildInputs = [x11 libXft libXrender zlib libjpeg libpng];

  configureFlags = "
    -v
    -system-zlib -system-libpng -system-libjpeg
    -qt-gif
    -I${xextproto}/include
    ${if openglSupport then "-dlopen-opengl
      -L${mesa}/lib -I${mesa}/include
      -L${libXmu}/lib -I${libXmu}/include" else ""}
    ${if threadSupport then "-thread" else "-no-thread"}
    ${if xrenderSupport then "-xrender -L${libXrender}/lib -I${libXrender}/include" else "-no-xrender"}
    ${if xrandrSupport then "-xrandr
      -L${libXrandr}/lib -I${libXrandr}/include
      -I${randrproto}/include" else "-no-xrandr"}
    ${if xineramaSupport then "-xinerama -L${libXinerama}/lib -I${libXinerama}/include" else "-no-xinerama"}
    ${if cursorSupport then "-L${libXcursor}/lib -I${libXcursor}/include" else ""}
    ${if mysqlSupport then "-qt-sql-mysql -L${mysql}/lib/mysql -I${mysql}/include/mysql" else ""}
    ${if xftSupport then "-xft
      -L${libXft}/lib -I${libXft}/include
      -L${libXft.freetype}/lib -I${libXft.freetype}/include
      -L${libXft.fontconfig}/lib -I${libXft.fontconfig}/include" else "-no-xft"}
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
}
