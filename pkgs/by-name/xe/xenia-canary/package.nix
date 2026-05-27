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
  alsa-lib,
  wrapGAppsHook3,
  makeDesktopItem,
  copyDesktopItems,
  glslang,
  spirv-tools,
  symlinkJoin,
  llvmPackages_20,
  autoPatchelfHook,
  unstableGitUpdater,
  fetchFromGitHub,
}:

let
  vulkan-sdk = symlinkJoin {
    name = "vulkan-sdk";
    paths = [
      glslang
      spirv-tools
    ];
  };
in
llvmPackages_20.stdenv.mkDerivation {
  pname = "xenia-canary";
  version = "0-unstable-2026-05-03";

  src = fetchFromGitHub {
    owner = "xenia-canary";
    repo = "xenia-canary";
    fetchSubmodules = true;
    rev = "9467c77f0825f3f8156038ef1a03e27b6c727393";
    hash = "sha256-hGr8KJcvLkluup5FN+MW7+ciuztgGO+SyTvKXYSHeIk=";
  };

  dontConfigure = true;

  nativeBuildInputs = [
    python3
    pkg-config
    ninja
    cmake
    wrapGAppsHook3
    copyDesktopItems
    glslang
    spirv-tools
    llvmPackages_20.lld
    autoPatchelfHook
    alsa-lib
    libuuid
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=unused-result"
  ];

  buildInputs = [
    gtk3
    lz4
    SDL2
  ];

  buildPhase = ''
    runHook preBuild
    export VULKAN_SDK="${vulkan-sdk}"
    python3 xenia-build.py setup
    python3 xenia-build.py build --config=release
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

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

  meta = {
    description = "Xbox 360 Emulator Research Project";
    homepage = "https://github.com/xenia-canary/xenia-canary";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ tuxy ];
    mainProgram = "xenia_canary";
    platforms = [ "x86_64-linux" ];
  };
}
