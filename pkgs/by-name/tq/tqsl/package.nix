{
  lib,
  stdenv,
  fetchurl,
  cmake,
  expat,
  openssl,
  zlib,
  lmdb,
  curl,
  sqlite,
  wxGTK32,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tqsl";
  version = "2.8.2";

  src = fetchurl {
    url = "https://www.arrl.org/files/file/LoTW%20Instructions/tqsl-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-HH78pTeT/wW9dZggxcqRiZ3OqShU7B2uPWa4ya59LfA=";
  };

  nativeBuildInputs = [
    cmake
    wrapGAppsHook3
  ];
  buildInputs = [
    expat
    openssl
    zlib
    lmdb
    curl
    sqlite
    wxGTK32
  ];

  meta = {
    description = "Software for using the ARRL Logbook of the World";
    mainProgram = "tqsl";
    homepage = "https://www.arrl.org/tqsl-download";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
