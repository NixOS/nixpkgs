{
  abseil-cpp,
  cmake,
  cmark-gfm,
  coreutils,
  fetchFromGitHub,
  fetchNpmDeps,
  glaze,
  kdePackages,
  lib,
  libqalculate,
  minizip,
  ninja,
  nodejs,
  npmHooks,
  pkg-config,
  protobuf,
  qt6,
  gcc15Stdenv,
  wayland,
  libxml2,
}:
gcc15Stdenv.mkDerivation (finalAttrs: {
  pname = "vicinae";
  version = "0.19.3";

  src = fetchFromGitHub {
    owner = "vicinaehq";
    repo = "vicinae";
    tag = "v${finalAttrs.version}";
    hash = "sha256-x/WIhul+slaDhW8PvcHpa/FElraGCWfFvgT7Xgw1Hbo=";
  };

  apiDeps = fetchNpmDeps {
    src = "${finalAttrs.src}/typescript/api";
    hash = "sha256-UsTpMR23UQBRseRo33nbT6z/UCjZByryWfn2AQSgm6U=";
  };

  extensionManagerDeps = fetchNpmDeps {
    src = "${finalAttrs.src}/typescript/extension-manager";
    hash = "sha256-wl8FDFB6Vl1zD0/s2EbU6l1KX4rwUW6dOZof4ebMMO8=";
  };

  cmakeFlags = lib.mapAttrsToList lib.cmakeFeature {
    "VICINAE_GIT_TAG" = "v${finalAttrs.version}";
    "VICINAE_PROVENANCE" = "nix";
    "INSTALL_NODE_MODULES" = "OFF";
    "INSTALL_BROWSER_NATIVE_HOST" = "OFF";
    "USE_SYSTEM_GLAZE" = "ON";
    "CMAKE_INSTALL_PREFIX" = placeholder "out";
    "CMAKE_INSTALL_DATAROOTDIR" = "share";
    "CMAKE_INSTALL_BINDIR" = "bin";
    "CMAKE_INSTALL_LIBDIR" = "lib";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
    nodejs
    pkg-config
    protobuf
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    abseil-cpp
    cmark-gfm
    glaze
    kdePackages.layer-shell-qt
    kdePackages.qtkeychain
    libqalculate
    minizip
    nodejs
    protobuf
    qt6.qtbase
    qt6.qtsvg
    qt6.qtwayland
    wayland
    libxml2
  ];

  postPatch = ''
    local postPatchHooks=()
    source ${npmHooks.npmConfigHook}/nix-support/setup-hook
    npmRoot=typescript/api npmDeps=${finalAttrs.apiDeps} npmConfigHook
    npmRoot=typescript/extension-manager npmDeps=${finalAttrs.extensionManagerDeps} npmConfigHook
  '';

  qtWrapperArgs = [
    "--prefix PATH :  ${
      lib.makeBinPath [
        nodejs
        (placeholder "out")
      ]
    }"
  ];

  postFixup = ''
    substituteInPlace $out/share/systemd/user/vicinae.service \
      --replace-fail "/bin/kill" "${lib.getExe' coreutils "kill"}"
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Native, fast, extensible launcher for the desktop";
    homepage = "https://github.com/vicinaehq/vicinae";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      whispersofthedawn
      zstg
    ];
    platforms = lib.platforms.linux;
    mainProgram = "vicinae";
  };
})
