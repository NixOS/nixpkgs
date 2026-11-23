{
  apple-sdk,
  applyPatches,
  cmake,
  cmark-gfm,
  coreutils,
  dos2unix,
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
  numen,
  pkg-config,
  qt6,
  stdenv,
  swift,
  wayland,
  libxml2,
  udevCheckHook,
  whisper-cpp,
  withLocalAI ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vicinae";
  version = "0.30.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "vicinaehq";
    repo = "vicinae";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uZYp/eYUhO9udRfE2hLf/+zl4tEY49EzqBwH5IH8BF8=";
  };

  apiDeps = fetchNpmDeps {
    src = "${finalAttrs.src}/src/typescript/api";
    hash = "sha256-4FEaBDJK9abcgz+vptuL4wQ8zhp+wpLbbR4Y79BVhEg=";
  };

  extensionManagerDeps = fetchNpmDeps {
    src = "${finalAttrs.src}/src/typescript/extension-manager";
    hash = "sha256-pEgqFgvdz7Bcc+LznCI+KlD1XEfUuWFWjS24MJ7sx3k=";
  };

  # Ported from upstream
  mathText = applyPatches {
    name = "jkqtmathtext-source";
    src = fetchFromGitHub {
      owner = "jkriege2";
      repo = "JKQtPlotter";
      rev = "d9b6f18eac22f5e9959a5415d7ba0d8780f24585";
      hash = "sha256-F1ffLmvJmF+k3l+d1usEgXo5A6MD7bReldM2rsaxiB0=";
    };
    nativeBuildInputs = [ dos2unix ];
    prePatch = ''
      dos2unix \
        lib/jkqtcommon/CMakeLists.txt \
        lib/jkqtcommon/jkqtpbasicimagetools.cpp \
        lib/jkqtcommon/jkqtpdebuggingtools.cpp \
        lib/jkqtcommon/jkqttools.cpp \
        lib/jkqtcommon/jkqttools.h \
        lib/jkqtmathtext/CMakeLists.txt
    '';
    patches = [
      "${finalAttrs.src}/cmake/patches/jkqtmathtext-implication.patch"
      "${finalAttrs.src}/cmake/patches/jkqtmathtext-font-discovery.patch"
      "${finalAttrs.src}/cmake/patches/jkqtmathtext-latex-braces.patch"
      "${finalAttrs.src}/cmake/patches/jkqtmathtext-no-widgets.patch"
    ];
  };

  # Upstream forces a universal build and ad-hoc signs the framework with codesign
  # in a post-build step. Nix builds for one system and signs during fixup.
  mediaRemoteAdapter = applyPatches {
    name = "mediaremote-adapter-source";
    src = fetchFromGitHub {
      owner = "ungive";
      repo = "mediaremote-adapter";
      rev = "0e82bf1c44ec39554fbfc402ec88a48c6ae2a0fd";
      hash = "sha256-1bbSKIBKptGSWq5ioeLYKQVhzxcJQk68p+0j2PO63JY=";
    };
    postPatch = ''
      substituteInPlace CMakeLists.txt \
        --replace-fail 'set(CMAKE_OSX_ARCHITECTURES "x86_64;arm64")' "" \
        --replace-fail "COMMAND codesign" "COMMAND true"
    '';
  };

  cmakeFlags =
    lib.mapAttrsToList lib.cmakeFeature {
      "VICINAE_GIT_TAG" = finalAttrs.src.tag;
      "VICINAE_PROVENANCE" = "nix";
      "INSTALL_NODE_MODULES" = "OFF";
      "USE_SYSTEM_CMARK_GFM" = "ON";
      "USE_SYSTEM_GLAZE" = "ON";
      "USE_SYSTEM_NUMEN" = "ON";
      "USE_SYSTEM_KF6" = "ON";
      "USE_SYSTEM_QT_KEYCHAIN" = "ON";
      "BUNDLE_SOULVER_CORE" = "OFF";
      "USE_SYSTEM_INFERENCE_ENGINES" = "ON";
      "CMAKE_INSTALL_PREFIX" = placeholder "out";
      "CMAKE_INSTALL_DATAROOTDIR" = "share";
      "CMAKE_INSTALL_BINDIR" = "bin";
      "CMAKE_INSTALL_LIBDIR" = "lib";
      "FETCHCONTENT_SOURCE_DIR_JKQTMATHTEXT" = "${finalAttrs.mathText}";
    }
    ++ [
      (lib.cmakeBool "LOCAL_AI" withLocalAI)
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_MEDIAREMOTEADAPTER" "${finalAttrs.mediaRemoteAdapter}")
    ];

  nativeBuildInputs = [
    cmake
    ninja
    nodejs
    pkg-config
    qt6.qttools
    qt6.wrapQtAppsHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
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
    numen
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtimageformats
    qt6.qtmultimedia
    qt6.qtsvg
    qt6.qtshadertools
    libxml2
  ]
  ++ lib.optionals withLocalAI [
    # Only the whisper and parakeet libraries are used.
    (whisper-cpp.override {
      withSDL = false;
      withFFmpegSupport = false;
    })
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
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      nodejs
      (placeholder "out")
    ])
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    app=$out/Applications/Vicinae.app
    install -Dm755 bin/vicinae-server "$app/Contents/MacOS/Vicinae"
    install -Dm755 bin/vicinae "$app/Contents/MacOS/vicinae-cli"
    install -Dm644 Info.plist "$app/Contents/Info.plist"
    install -Dm644 ../extra/vicinae.icns "$app/Contents/Resources/vicinae.icns"
    cp -r ../extra/themes "$app/Contents/Resources/themes"
    install -Dm755 ${finalAttrs.mediaRemoteAdapter}/bin/mediaremote-adapter.pl \
      "$app/Contents/Resources/mediaremote-adapter.pl"
    install -d "$app/Contents/Frameworks"
    cp -R _deps/mediaremoteadapter-build/MediaRemoteAdapter.framework "$app/Contents/Frameworks/"
    rm -rf "$app/Contents/Frameworks/MediaRemoteAdapter.framework/Versions/A/Headers"
    rm -f "$app/Contents/Frameworks/MediaRemoteAdapter.framework/Headers"
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
    maintainers = with lib.maintainers; [
      zstg
      nolight132
      miniharinn
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "vicinae";
  };
})
