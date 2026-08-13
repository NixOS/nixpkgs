{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  ctestCheckHook,
  libGLU,
  libunarr,
  expat,
  libdeflate,
  lerc,
  xz,
  libwebp,
  qtwebapp,
  pipewire,
  qt6Packages,
  onlyServer ? false,
}:
let
  qtPackages = qt6Packages;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "yacreader";
  version = "10.2.0";

  src = fetchFromGitHub {
    owner = "YACReader";
    repo = "yacreader";
    tag = finalAttrs.version;
    hash = "sha256-bqOukeAXTOMI/T5zoBsA9ZtEGq+6EV/zRH7c+nWX4Lc=";
  };

  patches = [
    # Devendor qtwebapp, use pkg-config instead
    ./qtwebapp-devendor.patch
  ];

  # Ensure devendor works
  postPatch = ''
    rm -rf third_party/QtWebApp
  '';

  # Pipewire is dlopen'd, so we must tell it where to look
  # So is qtwebapp on macOS
  preConfigure =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      qtWrapperArgs+=("--prefix" "LD_LIBRARY_PATH" ":" "${lib.makeLibraryPath [ pipewire ]}")
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      qtWrapperArgs+=("--prefix" "DYLD_LIBRARY_PATH" ":" "${lib.makeLibraryPath [ qtwebapp ]}")
    '';

  strictDeps = true;
  __structuredAttrs = true;

  cmakeFlags = [
    # force unarr backend on all platforms
    (lib.cmakeBool "BUILD_SERVER_STANDALONE" onlyServer)
    (lib.cmakeFeature "DECOMPRESSION_BACKEND" "unarr")
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    qtPackages.wrapQtAppsHook
  ];

  buildInputs = [
    libGLU
    libunarr
    expat
    libdeflate
    lerc
    xz
    libwebp
    qtwebapp
    qtPackages.qtbase
    qtPackages.qttools
    qtPackages.qtmultimedia
    qtPackages.qtspeech
    qtPackages.poppler
    qtPackages.qt5compat
  ];

  doCheck = true;
  nativeCheckInputs = [
    ctestCheckHook
  ];

  # custom Darwin install instructions taken from the upstream compileOSX.sh script
  installPhase = lib.optionalString stdenv.hostPlatform.isDarwin ''
    runHook preInstall

    mkdir -p "$out"/Applications
    mkdir -p "$out/Applications/YACReader.app/Contents/MacOS/languages"
    mkdir -p "$out/Applications/YACReaderLibrary.app/Contents/MacOS/languages"
    mkdir -p "$out/Applications/YACReaderLibraryServer.app/Contents/MacOS/languages"

    cp -r bin/YACReader.app "$out"/Applications/
    cp -r bin/YACReaderLibrary.app "$out"/Applications/
    cp -r bin/YACReaderLibraryServer.app "$out"/Applications/

    find . -name "*.qm" ! -name "*_source.qm" -exec cp {} "$out/Applications/YACReader.app/Contents/MacOS/languages/" \;
    find . -name "*.qm" ! -name "*_source.qm" -exec cp {} "$out/Applications/YACReaderLibrary.app/Contents/MacOS/languages/" \;
    find . -name "*.qm" ! -name "*_source.qm" -exec cp {} "$out/Applications/YACReaderLibraryServer.app/Contents/MacOS/languages/" \;

    runHook postInstall
  '';

  meta = {
    description = "Comic reader for cross-platform reading and managing your digital comic collection";
    homepage = "https://www.yacreader.com";
    license = lib.licenses.gpl3;
    mainProgram = "YACReader";
    maintainers = [ ];
  };
})
