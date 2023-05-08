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
, catch2
}:

stdenv.mkDerivation (finalAttrs: rec {
  version = "0.10.0";
  pname = "podofo";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    hash = "sha256-W61ufT/YT8DLVpGM2ai7ZFE6mR+vassyK8Ool/nAfU4=";
    fetchSubmodules = true;  # includes test data
  };

  prePatch = ''
    # remove any possibility it may try to use these
    rm -r extern/deps
  '';

  outputs = [ "out" "dev" "lib" ];

  nativeBuildInputs = [ cmake pkg-config ];

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

  nativeCheckInputs = [ catch2 ];

  cmakeFlags = [
    "-DPODOFO_BUILD_TEST=${if finalAttrs.finalPackage.doCheck then "ON" else "OFF"}"
    "-DCMAKE_BUILD_WITH_INSTALL_NAME_DIR=ON"
  ];

  postInstall = ''
    moveToOutput lib "$lib"
  '';

  doCheck = true;

  meta = with lib; {
    homepage = "https://podofo.sourceforge.net";
    description = "A library to work with the PDF file format";
    platforms = platforms.all;
    license = with licenses; [ gpl2Plus lgpl2Plus ];
  };
})
