{
  lib,
  stdenv,
  fetchurl,
  lzip,
  lzlib,
  texinfo,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tarlz";
  version = "0.28.1";
  outputs = [
    "out"
    "man"
    "info"
  ];

  nativeBuildInputs = [
    lzip
    texinfo
    versionCheckHook
  ];
  buildInputs = [ lzlib ];

  src = fetchurl {
    url = "mirror://savannah/lzip/tarlz/tarlz-${finalAttrs.version}.tar.lz";
    sha256 = "sha256-qzySt/fxDJU5vHvmkfumSK8h1MieVdgexm12H43Ytak=";
  };

  enableParallelBuilding = true;
  makeFlags = [ "CXX:=$(CXX)" ];

  doCheck = false; # system clock issues
  doInstallCheck = true;

  meta = with lib; {
    homepage = "https://www.nongnu.org/lzip/tarlz.html";
    description = "Massively parallel combined implementation of the tar archiver and the lzip compressor";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    mainProgram = "tarlz";
  };
})
