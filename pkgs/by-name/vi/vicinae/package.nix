{
  apple-sdk,
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
  swift,
  wayland,
  libxml2,
  udevCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vicinae";
  version = "0.23.2";

  src = fetchFromGitHub {
    owner = "vicinaehq";
    repo = "vicinae";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/5fGvMWlLlyd5ibK7y1dqIK1MTpLABj3v1M0r/VArww=";
  };

  apiDeps = fetchNpmDeps {
    src = "${finalAttrs.src}/src/typescript/api";
    hash = "sha256-4FEaBDJK9abcgz+vptuL4wQ8zhp+wpLbbR4Y79BVhEg=";
  };

  extensionManagerDeps = fetchNpmDeps {
    src = "${finalAttrs.src}/src/typescript/extension-manager";
    hash = "sha256-pEgqFgvdz7Bcc+LznCI+KlD1XEfUuWFWjS24MJ7sx3k=";
  };

  cmakeFlags = lib.mapAttrsToList lib.cmakeFeature {
    "VICINAE_GIT_TAG" = "v${finalAttrs.version}";
    "VICINAE_PROVENANCE" = "nix";
    "INSTALL_NODE_MODULES" = "OFF";
    "INSTALL_BROWSER_NATIVE_HOST" = "OFF";
    "USE_SYSTEM_CMARK_GFM" = "ON";
    "USE_SYSTEM_GLAZE" = "ON";
    "USE_SYSTEM_KF6" = "ON";
    "USE_SYSTEM_QT_KEYCHAIN" = "ON";
    "BUNDLE_SOULVER_CORE" = "OFF";
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
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    qt6.qttools
    swift
  ];

  buildInputs = [
    cmark-gfm
    glaze
    kdePackages.qtkeychain
    kdePackages.syntax-highlighting
    libqalculate
    minizip
    nodejs
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtimageformats
    qt6.qtsvg
    qt6.qtshadertools
    libxml2
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    kdePackages.layer-shell-qt
    qt6.qtwayland
    wayland
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk
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

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    app=$out/Applications/Vicinae.app
    install -Dm755 bin/vicinae-server "$app/Contents/MacOS/Vicinae"
    install -Dm755 bin/vicinae "$app/Contents/MacOS/vicinae-cli"
    install -Dm644 Info.plist "$app/Contents/Info.plist"
    install -Dm644 ../extra/vicinae.icns "$app/Contents/Resources/vicinae.icns"
    cp -r ../extra/themes "$app/Contents/Resources/themes"
    rm -f "$out/bin/vicinae"
  '';

  postFixup =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      substituteInPlace $out/share/systemd/user/vicinae.service \
        --replace-fail "/bin/kill" "${lib.getExe' coreutils "kill"}"\
        --replace-fail "ExecStart=vicinae" "ExecStart=$out/bin/vicinae"
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      ln -s ../Applications/Vicinae.app/Contents/MacOS/vicinae-cli "$out/bin/vicinae"
    '';

  doInstallCheck = stdenv.hostPlatform.isLinux;
  nativeInstallCheckInputs = lib.optionals stdenv.hostPlatform.isLinux [ udevCheckHook ];

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Native, fast, extensible launcher for the desktop";
    homepage = "https://github.com/vicinaehq/vicinae";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ zstg ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "vicinae";
  };
})
