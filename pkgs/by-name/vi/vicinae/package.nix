{
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
  qt6,
  stdenv,
  wayland,
  libxml2,
  udevCheckHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "vicinae";
  version = "0.20.13";

  src = fetchFromGitHub {
    owner = "vicinaehq";
    repo = "vicinae";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zRoOKeQ4ne7o7mILwb+5PKE75FhoqkG/HizWs7bKrDo=";
  };

  apiDeps = fetchNpmDeps {
    src = "${finalAttrs.src}/src/typescript/api";
    hash = "sha256-lIXhMBJHujs6d9fXEK8Q+sfjkKyFJEMEtKrQorkfPeU=";
  };

  extensionManagerDeps = fetchNpmDeps {
    src = "${finalAttrs.src}/src/typescript/extension-manager";
    hash = "sha256-gpbS6MIHOSuHIfd4zDEB4EcMi9LHk9tPdnxwT0S0nbA=";
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
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    cmark-gfm
    glaze
    kdePackages.layer-shell-qt
    kdePackages.qtkeychain
    kdePackages.syntax-highlighting
    libqalculate
    minizip
    nodejs
    qt6.qtbase
    qt6.qtsvg
    qt6.qtwayland
    wayland
    libxml2
  ];

  postPatch = ''
    # Toggle telemetry from opt-out to opt-in
    substituteInPlace extra/config.jsonc \
      --replace-fail '"system_info": true' '"system_info": false'

    local postPatchHooks=()
    source ${npmHooks.npmConfigHook}/nix-support/setup-hook
    npmRoot=src/typescript/api npmDeps=${finalAttrs.apiDeps} npmConfigHook
    npmRoot=src/typescript/extension-manager npmDeps=${finalAttrs.extensionManagerDeps} npmConfigHook
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
      --replace-fail "/bin/kill" "${lib.getExe' coreutils "kill"}"\
      --replace-fail "ExecStart=vicinae" "ExecStart=$out/bin/vicinae"
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ udevCheckHook ];

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
