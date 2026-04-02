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
  version = "0.29";
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
    sha256 = "sha256-fhJ/HhsbYspuNBf94y864EgbpYhvVqhVOiFbGdgcbBk=";
  };

  enableParallelBuilding = true;
  makeFlags = [ "CXX:=$(CXX)" ];

  doCheck = false; # system clock issues
  doInstallCheck = true;

  meta = {
    homepage = "https://www.nongnu.org/lzip/tarlz.html";
    description = "Massively parallel combined implementation of the tar archiver and the lzip compressor";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    mainProgram = "tarlz";
  };
})
