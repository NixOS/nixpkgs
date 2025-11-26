{
  abseil-cpp,
  cmake,
  cmark-gfm,
  fetchFromGitHub,
  fetchNpmDeps,
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
  version = "0.16.10";

  src = fetchFromGitHub {
    owner = "vicinaehq";
    repo = "vicinae";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4t0AscBe+TMhQ5SuzkBSgKrMXGs/2BvlRv8ke3pg+yo=";
  };

  apiDeps = fetchNpmDeps {
    src = "${finalAttrs.src}/typescript/api";
    hash = "sha256-4OgVCnw5th2TcXszVY5G9ENr3/Y/eR2Kd45DbUhQRNk=";
  };

  extensionManagerDeps = fetchNpmDeps {
    src = "${finalAttrs.src}/typescript/extension-manager";
    hash = "sha256-krDFHTG8irgVk4a79LMz148drLgy2oxEoHCKRpur1R4=";
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

  passthru.updateScript = ./update.sh;

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
