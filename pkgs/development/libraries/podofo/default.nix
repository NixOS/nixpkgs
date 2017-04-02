{ stdenv, fetchurl, cmake, zlib, freetype, libjpeg, libtiff, fontconfig
, gcc5, openssl, libpng, lua5, pkgconfig, libidn, expat }:

stdenv.mkDerivation rec {
  name = "podofo-0.9.5";

  src = fetchurl {
    url = "mirror://sourceforge/podofo/${name}.tar.gz";
    sha256 = "012kgfx5j5n6w4zkc1d290d2cwjk60jhzsjlr2x19g3yi75q2jc5";
  };

  propagatedBuildInputs = [ zlib freetype libjpeg libtiff fontconfig openssl libpng libidn expat ];
  nativeBuildInputs = [ cmake gcc5 pkgconfig ];
  buildInputs = [ lua5 stdenv.cc.libc ];

  crossAttrs = {
    propagatedBuildInputs = [ zlib.crossDrv freetype.crossDrv libjpeg.crossDrv
      libtiff.crossDrv fontconfig.crossDrv openssl.crossDrv libpng.crossDrv
      lua5.crossDrv stdenv.ccCross.libc ];
  };

  cmakeFlags = "-DPODOFO_BUILD_SHARED=ON -DPODOFO_BUILD_STATIC=OFF";

  meta = {
    homepage = http://podofo.sourceforge.net;
    description = "A library to work with the PDF file format";
    platforms = stdenv.lib.platforms.all;
    maintainers = [ ];
  };
}
