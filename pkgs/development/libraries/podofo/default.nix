{ stdenv, fetchurl, cmake, zlib, freetype, libjpeg, libtiff, fontconfig
, openssl, libpng, lua5, pkgconfig, libidn, expat
, gcc5 # TODO(@Dridus) remove this at next hash break
}:

stdenv.mkDerivation rec {
  name = "podofo-0.9.6";

  src = fetchurl {
    url = "mirror://sourceforge/podofo/${name}.tar.gz";
    sha256 = "0wj0y4zcmj4q79wrn3vv3xq4bb0vhhxs8yifafwy9f2sjm83c5p9";
  };

  propagatedBuildInputs = [ zlib freetype libjpeg libtiff fontconfig openssl libpng libidn expat ];

  # TODO(@Dridus) remove the ++ ghc5 at next hash break
  nativeBuildInputs = [ cmake pkgconfig ] ++ stdenv.lib.optional stdenv.isLinux gcc5;

  # TODO(@Dridus) remove the ++ libc at next hash break
  buildInputs = [ lua5 ] ++ stdenv.lib.optional stdenv.isLinux stdenv.cc.libc;

  preConfigure = ''
    CC=${stdenv.cc.targetPrefix}cc
    CXX=${stdenv.cc.targetPrefix}c++
  '';

  cmakeFlags = "-DPODOFO_BUILD_SHARED=ON -DPODOFO_BUILD_STATIC=OFF";

  meta = {
    homepage = http://podofo.sourceforge.net;
    description = "A library to work with the PDF file format";
    platforms = stdenv.lib.platforms.all;
    maintainers = [ ];
  };
}
