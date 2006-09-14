{ stdenv, fetchurl
, xftSupport ? true, libXft ? null
, xrenderSupport ? true, libXrender ? null
, xrandrSupport ? true, libXrandr ? null, randrproto ? null
, xineramaSupport ? true, libXinerama ? null, xineramaproto ? null
, threadSupport ? true
, mysqlSupport ? true, mysql ? null
, openglSupport ? false, mesa ? null, libXmu ? null
, x11, zlib, libjpeg, libpng, which
}:

assert xftSupport -> libXft != null;
assert xrenderSupport -> xftSupport && libXrender != null;
assert xrandrSupport -> libXrandr != null && randrproto != null;
assert mysqlSupport -> mysql != null;
assert openglSupport -> mesa != null && libXmu != null;

stdenv.mkDerivation {
  name = "qt-3.3.6";

  builder = ./builder.sh;
  substitute = ../../../build-support/substitute/substitute.sh;
  hook = ./setup-hook.sh;  
  src = fetchurl {
    url = ftp://ftp.trolltech.com/qt/source/qt-x11-free-3.3.6.tar.bz2;
    md5 = "dc1384c03ac08af21f6fefab32d982cf";
  };

  buildInputs = [x11 libXft libXrender zlib libjpeg libpng which];

  configureFlags = "
    -v
    -system-zlib -system-libpng -system-libjpeg
    ${if openglSupport then "-dlopen-opengl
      -L${mesa}/lib -I${mesa}/include
      -L${libXmu}/lib -I${libXmu}/include" else ""}
    ${if threadSupport then "-thread" else "-no-thread"}
    ${if xrenderSupport then "-xrender -L${libXrender}/lib -I${libXrender}/include" else "-no-xrender"}
    ${if xrandrSupport then "-xrandr
      -L${libXrandr}/lib -I${libXrandr}/include
      -I${randrproto}/include" else "-no-xrandr"}
    ${if xineramaSupport then "-xinerama -L${libXinerama}/lib -I${xineramaproto}/include" else "-no-xinerama"}
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
  ];
}
