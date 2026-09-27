{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  ctestCheckHook,
  libGLU,
  libarchive,
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

  # libarchive reads RAR5 under a free license and already ships in nixpkgs core,
  # so it is the Linux backend; it is Linux-only upstream, so Darwin keeps unarr.
  # (YACReader's 7zip backend also reads RAR5, but only via a runtime 7z.so built
  #  with the unfree unRAR codec, which would make this package unfree.)
  useLibarchive = stdenv.hostPlatform.isLinux;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "yacreader";
  version = "10.0.0";

  src = fetchFromGitHub {
    owner = "YACReader";
    repo = "yacreader";
    tag = finalAttrs.version;
    hash = "sha256-nJ4S4ej/I+ifDNa3CPpusFpDsEwZwYDt0JLaebptjuU=";
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
  preConfigure = ''
    qtWrapperArgs+=("--prefix" "LD_LIBRARY_PATH" ":" "${lib.makeLibraryPath [ pipewire ]}")
  '';

  strictDeps = true;
  __structuredAttrs = true;

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SERVER_STANDALONE" onlyServer)
    (lib.cmakeFeature "PDF_BACKEND" "poppler")
    (lib.cmakeFeature "DECOMPRESSION_BACKEND" (if useLibarchive then "libarchive" else "unarr"))
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    qtPackages.wrapQtAppsHook
  ];

  buildInputs = [
    libGLU
    (if useLibarchive then libarchive else libunarr)
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
})
