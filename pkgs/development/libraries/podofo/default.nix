{ stdenv, fetchurl, cmake, zlib, freetype, libjpeg, libtiff, fontconfig
, openssl, libpng, lua5, pkgconfig, libidn, expat, fetchpatch
, gcc5 # TODO(@Dridus) remove this at next hash break
}:

stdenv.mkDerivation rec {
  version = "0.9.6";
  name = "podofo-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/podofo/${name}.tar.gz";
    sha256 = "0wj0y4zcmj4q79wrn3vv3xq4bb0vhhxs8yifafwy9f2sjm83c5p9";
  };

  propagatedBuildInputs = [ zlib freetype libjpeg libtiff fontconfig openssl libpng libidn expat ];

  patches = [
    # https://sourceforge.net/p/podofo/tickets/24/
    (fetchpatch {
      url = "https://sourceforge.net/p/podofo/tickets/24/attachment/podofo-cmake-3.12.patch";
      extraPrefix = "";
      sha256 = "087h51x60zrakzx09baan77hwz99cwb5l1j802r5g4wj7pbjz0mb";
    })
  ];

  # TODO(@Dridus) remove the ++ ghc5 at next hash break
  nativeBuildInputs = [ cmake pkgconfig ] ++ stdenv.lib.optional stdenv.isLinux gcc5;

  # TODO(@Dridus) remove the ++ libc at next hash break
  buildInputs = [ lua5 ] ++ stdenv.lib.optional stdenv.isLinux stdenv.cc.libc;

  cmakeFlags = "-DPODOFO_BUILD_SHARED=ON -DPODOFO_BUILD_STATIC=OFF";

  postFixup = stdenv.lib.optionalString stdenv.isDarwin ''
    for i in $out/bin/* ; do
      install_name_tool -change libpodofo.${version}.dylib $out/lib/libpodofo.${version}.dylib "$i"
    done
  '';

  meta = with stdenv.lib; {
    homepage = http://podofo.sourceforge.net;
    description = "A library to work with the PDF file format";
    platforms = platforms.all;
    license = with licenses; [ gpl2 lgpl2 ];
  };
}
