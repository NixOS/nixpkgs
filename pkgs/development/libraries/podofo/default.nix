{ lib, stdenv, fetchurl, cmake, zlib, freetype, libjpeg, libtiff, fontconfig
, openssl, libpng, lua5, pkg-config, libidn, expat
}:

stdenv.mkDerivation rec {
  version = "0.9.8";
  pname = "podofo";

  src = fetchurl {
    url = "mirror://sourceforge/podofo/${pname}-${version}.tar.gz";
    sha256 = "sha256-XeYH4V8ZK4rZBzgwB1nYjeoPXM3OO/AASKDJMrxkUVQ=";
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

  postPatch = ''
    # Use GNU directories to fix multiple outputs
    failNoMatches='t yes; b no; :yes h; :no p; $ {x; /./{x;q}; q1}'
    sed -ni src/podofo/CMakeLists.txt \
        -e 's/LIBDIRNAME/CMAKE_INSTALL_LIBDIR/' -e "$failNoMatches"
    sed -ni src/podofo/libpodofo.pc.in \
        -e 's/^libdir=.*/libdir=@CMAKE_INSTALL_LIBDIR@/' -e "$failNoMatches"
  '';

  meta = with lib; {
    homepage = "https://podofo.sourceforge.net";
    description = "Library to work with the PDF file format";
    platforms = platforms.all;
    license = with licenses; [ gpl2Plus lgpl2Plus ];
  };
}
