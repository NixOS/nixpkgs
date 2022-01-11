{ lib, stdenv, fetchurl, cmake, zlib, freetype, libjpeg, libtiff, fontconfig
, openssl, libpng, lua5, pkg-config, libidn, expat
}:

stdenv.mkDerivation rec {
  version = "0.9.7";
  pname = "podofo";

  src = fetchurl {
    url = "mirror://sourceforge/podofo/${pname}-${version}.tar.gz";
    sha256 = "1f0yvkx6nf99fp741w2y706d8bs9824x1z2gqm3rdy5fv8bfgwkw";
  };

  outputs = [ "out" "dev" "lib" ];

  nativeBuildInputs = [ cmake pkg-config ];

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

  meta = with lib; {
    homepage = "http://podofo.sourceforge.net";
    description = "A library to work with the PDF file format";
    platforms = platforms.all;
    license = with licenses; [ gpl2Plus lgpl2Plus ];
  };
}
