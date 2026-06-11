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
  wxwidgets_3_2,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tqsl";
  version = "2.8.4";

  src = fetchurl {
    url = "https://www.arrl.org/files/file/LoTW%20Instructions/tqsl-${finalAttrs.version}.tar.gz";
    hash = "sha256-bnGXKrH2c0Ng/50Rbzg4z3M6D/EuJ0mkYIThoU94QPw=";
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
    wxwidgets_3_2
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
