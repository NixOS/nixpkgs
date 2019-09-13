{ stdenv, fetchurl, cmake, zlib, freetype, libjpeg, libtiff, fontconfig
, openssl, libpng, lua5, pkgconfig, libidn, expat, fetchpatch
}:

stdenv.mkDerivation rec {
  version = "0.9.6";
  pname = "podofo";

  src = fetchurl {
    url = "mirror://sourceforge/podofo/${pname}-${version}.tar.gz";
    sha256 = "0wj0y4zcmj4q79wrn3vv3xq4bb0vhhxs8yifafwy9f2sjm83c5p9";
  };

  patches = [
    # https://sourceforge.net/p/podofo/tickets/24/
    (fetchpatch {
      url = "https://sourceforge.net/p/podofo/tickets/24/attachment/podofo-cmake-3.12.patch";
      extraPrefix = "";
      sha256 = "087h51x60zrakzx09baan77hwz99cwb5l1j802r5g4wj7pbjz0mb";
    })
  ];

  outputs = [ "out" "dev" "lib" ];

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ zlib freetype libjpeg libtiff fontconfig openssl libpng
                  libidn expat lua5 ];

  cmakeFlags = [
    "-DPODOFO_BUILD_SHARED=ON"
    "-DPODOFO_BUILD_STATIC=OFF"
    "-DCMAKE_BUILD_WITH_INSTALL_NAME_DIR=ON"
  ];

  postInstall = ''
    moveToOutput lib "$lib"
  '';

  meta = with stdenv.lib; {
    homepage = http://podofo.sourceforge.net;
    description = "A library to work with the PDF file format";
    platforms = platforms.all;
    license = with licenses; [ gpl2 lgpl2 ];
  };
}
