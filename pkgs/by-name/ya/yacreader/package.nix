{
  lib,
  stdenv,
  fetchFromGitHub,
  libGLU,
  libunarr,
  libsForQt5,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "yacreader";
  version = "9.15.0";

  src = fetchFromGitHub {
    owner = "YACReader";
    repo = "yacreader";
    tag = version;
    hash = "sha256-5vCjr8WRwa7Q/84Itgg07K1CJKGnWA1z53et2IxxReE=";
  };

  patches = [
    # make the unarr backend logic use pkg-config even on Darwin
    ./darwin-unarr-use-pkg-config.patch
  ];

  qmakeFlags = [
    # force unarr backend on all platforms
    "CONFIG+=unarr"
  ];

  nativeBuildInputs = [
    libsForQt5.qmake
    libsForQt5.qttools # for translations
    libsForQt5.wrapQtAppsHook
    pkg-config
  ];

  buildInputs = [
    libGLU
    libsForQt5.poppler
    libsForQt5.qtgraphicaleffects # imported, but not declared as a dependency
    libsForQt5.qtmultimedia
    libsForQt5.qtquickcontrols2
    libunarr
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libsForQt5.qtmacextras # can be removed when using qt6
  ];

  # custom Darwin install instructions taken from the upstream compileOSX.sh script
  installPhase = lib.optionalString stdenv.hostPlatform.isDarwin ''
    runHook preInstall

    mkdir -p "$out"/Applications

    cp -r YACReader/YACReader.app "$out"/Applications/
    cp -r YACReaderLibrary/YACReaderLibrary.app "$out"/Applications/
    cp -r YACReaderLibraryServer/YACReaderLibraryServer.app "$out"/Applications/

    cp -r release/server "$out"/Applications/YACReaderLibrary.app/Contents/MacOS/
    cp -r release/server "$out"/Applications/YACReaderLibraryServer.app/Contents/MacOS/
    cp -r release/languages "$out"/Applications/YACReader.app/Contents/MacOS/
    cp -r release/languages "$out"/Applications/YACReaderLibrary.app/Contents/MacOS/
    cp -r release/languages "$out"/Applications/YACReaderLibraryServer.app/Contents/MacOS/

    makeWrapper "$out"/Applications/YACReader.app/Contents/MacOS/YACReader "$out/bin/YACReader"
    makeWrapper "$out"/Applications/YACReaderLibrary.app/Contents/MacOS/YACReaderLibrary "$out/bin/YACReaderLibrary"
    makeWrapper "$out"/Applications/YACReaderLibraryServer.app/Contents/MacOS/YACReaderLibraryServer "$out/bin/YACReaderLibraryServer"

    runHook postInstall
  '';

  meta = {
    description = "Comic reader for cross-platform reading and managing your digital comic collection";
    homepage = "https://www.yacreader.com";
    license = lib.licenses.gpl3;
    mainProgram = "YACReader";
    maintainers = [ ];
  };
}
