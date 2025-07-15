{
  lib,
  python3,
  gtk3,
  lz4,
  SDL2,
  pkg-config,
  vulkan-loader,
  ninja,
  cmake,
  libuuid,
  wrapGAppsHook3,
  makeDesktopItem,
  copyDesktopItems,
  llvmPackages_18,
  autoPatchelfHook,
  unstableGitUpdater,
  fetchFromGitHub,
}:
llvmPackages_18.stdenv.mkDerivation {
  pname = "xenia-canary";
  version = "0-unstable-2025-06-07";

  src = fetchFromGitHub {
    owner = "xenia-canary";
    repo = "xenia-canary";
    fetchSubmodules = true;
    rev = "422517c673bba086c2b857946ae5a37ee35b8e50";
    hash = "sha256-88GHKXURfN8vaVNN7wKn562b6FvsIm/sTcUgtuhvVxM=";
  };

  dontConfigure = true;

  nativeBuildInputs = [
    python3
    pkg-config
    ninja
    cmake
    wrapGAppsHook3
    copyDesktopItems
    autoPatchelfHook
    libuuid
  ];

  NIX_CFLAGS_COMPILE = [
    "-Wno-error=unused-result"
  ];

  buildInputs = [
    gtk3
    lz4
    SDL2
  ];

  buildPhase = ''
    runHook preBuild
    python3 xenia-build setup
    python3 xenia-build build --config=release -j $NIX_BUILD_CORES
    runHook postBuild
  '';

  runtimeDependencies = [
    vulkan-loader
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "xenia_canary";
      desktopName = "Xenia Canary";
      genericName = "Xbox 360 Emulator";
      exec = "xenia_canary";
      comment = "Xbox 360 Emulator Research Project";
      icon = "xenia-canary";
      startupWMClass = "Xenia_canary";
      categories = [
        "Game"
        "Emulator"
      ];
      keywords = [ "xbox" ];
    })
  ];

  installPhase = ''
    runHook preInstall
    find ./build/bin -mindepth 3 -maxdepth 3 -type f -executable -exec install -Dm755 {} -t $out/bin \;
    for width in 16 32 48 64 128 256; do
      install -Dm644 assets/icon/$width.png $out/share/icons/hicolor/''${width}x''${width}/apps/xenia-canary.png
    done
    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Xbox 360 Emulator Research Project";
    homepage = "https://github.com/xenia-canary/xenia-canary";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ tuxy ];
    mainProgram = "xenia_canary";
    platforms = [ "x86_64-linux" ];
  };
}
