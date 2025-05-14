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
  version = "0.27.1";
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
    sha256 = "7091968e8f9b5333730e7a558ebf5aa9089d9f0528e6aea994c6f24a9d46a03f";
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
    maintainers = with maintainers; [ ehmry ];
    mainProgram = "tarlz";
  };
})
