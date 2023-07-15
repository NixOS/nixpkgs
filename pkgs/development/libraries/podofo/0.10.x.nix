{ lib
, stdenv
, fetchFromGitHub
, cmake
, expat
, fontconfig
, freetype
, libidn
, libjpeg
, libpng
, libtiff
, libxml2
, lua5
, openssl
, pkg-config
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "podofo";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "podofo";
    repo = "podofo";
    rev = finalAttrs.version;
    hash = "sha256-Y5dpx0otX14Jig/O/oq+Sfdcia1a0bhT/6k8nwg+k5o=";
  };

  outputs = [ "out" "dev" "lib" ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    expat
    fontconfig
    freetype
    libidn
    libjpeg
    libpng
    libtiff
    libxml2
    lua5
    openssl
    zlib
  ];

  cmakeFlags = [
    "-DPODOFO_BUILD_STATIC=${if stdenv.hostPlatform.isStatic then "ON" else "OFF"}"
    "-DCMAKE_BUILD_WITH_INSTALL_NAME_DIR=ON"
  ];

  postInstall = ''
    moveToOutput lib "$lib"
  '';

  meta = {
    homepage = "https://github.com/podofo/podofo";
    description = "A library to work with the PDF file format";
    platforms = lib.platforms.all;
    license = with lib.licenses; [ gpl2Plus lgpl2Plus ];
    maintainers = [];
  };
})
