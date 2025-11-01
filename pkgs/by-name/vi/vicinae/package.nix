{
  cmake,
  cmark-gfm,
  fetchFromGitHub,
  fetchNpmDeps,
  grpc-tools,
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
  rapidfuzz-cpp,
  stdenv,
  wayland,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "vicinae";
  version = "0.15.5";

  src = fetchFromGitHub {
    owner = "vicinaehq";
    repo = "vicinae";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3pKexTUWfohL/S/yWsVMShmtMlBFI9zsd7NFzySKG0w=";
  };

  apiDeps = fetchNpmDeps {
    src = "${finalAttrs.src}/typescript/api";
    hash = "sha256-dSHEzw15lSRRbldl9PljuWFf2htdG+HgSeKPAB88RBg=";
  };

  extensionManagerDeps = fetchNpmDeps {
    src = "${finalAttrs.src}/typescript/extension-manager";
    hash = "sha256-TCT7uZRZn4rsLA/z2yLeK5Bt4DJPmdSC4zkmuCxTtc8=";
  };

  cmakeFlags = lib.mapAttrsToList lib.cmakeFeature {
    "VICINAE_GIT_TAG" = "v${finalAttrs.version}";
    "VICINAE_PROVENANCE" = "nix";
    "INSTALL_NODE_MODULES" = "OFF";
    "CMAKE_INSTALL_PREFIX" = placeholder "out";
    "CMAKE_INSTALL_DATAROOTDIR" = "share";
    "CMAKE_INSTALL_BINDIR" = "bin";
    "CMAKE_INSTALL_LIBDIR" = "lib";
  };

  nativeBuildInputs = [
    cmake
    ninja
    nodejs
    pkg-config
    protobuf
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    cmark-gfm
    grpc-tools
    kdePackages.layer-shell-qt
    kdePackages.qtkeychain
    libqalculate
    minizip
    nodejs
    protobuf
    qt6.qtbase
    qt6.qtsvg
    qt6.qtwayland
    rapidfuzz-cpp
    wayland
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

  meta = {
    description = "A focused launcher for your desktop — native, fast, extensible";
    homepage = "https://github.com/vicinaehq/vicinae";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      dawnofmidnight
      zstg
    ];
    platforms = lib.platforms.linux;
    mainProgram = "vicinae";
  };
})
