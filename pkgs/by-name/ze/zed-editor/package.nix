{
  lib,
  rustPlatform,
  fetchFromGitHub,
  clang,
  cmake,
  copyDesktopItems,
  curl,
  perl,
  pkg-config,
  protobuf,
  xcbuild,
  fontconfig,
  freetype,
  libgit2,
  openssl,
  sqlite,
  zlib,
  zstd,
  alsa-lib,
  libxkbcommon,
  wayland,
  libglvnd,
  xorg,
  stdenv,
  darwin,
  makeFontsConf,
  vulkan-loader,
  envsubst,
  nix-update-script,
  cargo-about,
  testers,
  zed-editor,
  buildFHSEnv,

  withGLES ? false,
}:

assert withGLES -> stdenv.hostPlatform.isLinux;

let
  executableName = "zeditor";
  # Based on vscode.fhs
  # Zed allows for users to download and use extensions
  # which often include the usage of pre-built binaries.
  # See #309662
  #
  # buildFHSEnv allows for users to use the existing Zed
  # extension tooling without significant pain.
  fhs =
    {
      additionalPkgs ? pkgs: [ ],
    }:
    buildFHSEnv {
      # also determines the name of the wrapped command
      name = executableName;

      # additional libraries which are commonly needed for extensions
      targetPkgs =
        pkgs:
        (with pkgs; [
          # ld-linux-x86-64-linux.so.2 and others
          glibc
        ])
        ++ additionalPkgs pkgs;

      # symlink shared assets, including icons and desktop entries
      extraInstallCommands = ''
        ln -s "${zed-editor}/share" "$out/"
      '';

      runScript = "${zed-editor}/bin/${executableName}";

      passthru = {
        inherit executableName;
        inherit (zed-editor) pname version;
      };

      meta = zed-editor.meta // {
        description = ''
          Wrapped variant of ${zed-editor.pname} which launches in a FHS compatible environment.
          Should allow for easy usage of extensions without nix-specific modifications.
        '';
      };
    };
in
rustPlatform.buildRustPackage rec {
  pname = "zed-editor";
  version = "0.154.2";

  src = fetchFromGitHub {
    owner = "zed-industries";
    repo = "zed";
    rev = "refs/tags/v${version}";
    hash = "sha256-DcSlsBwZW2RhzX74eNi0+VBwnxYLl22CbCbZrEOSiFQ=";
    fetchSubmodules = true;
  };

  patches = [
    # Zed uses cargo-install to install cargo-about during the script execution.
    # We provide cargo-about ourselves and can skip this step.
    ./0001-generate-licenses.patch
  ];

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "alacritty_terminal-0.24.1-dev" = "sha256-b4oSDhsAAYjpYGfFgA1Q1642JoJQ9k5RTsPgFUpAFmc=";
      "async-pipe-0.1.3" = "sha256-g120X88HGT8P6GNCrzpS5SutALx5H+45Sf4iSSxzctE=";
      "blade-graphics-0.5.0" = "sha256-j/JI34ZPD7RAHNHu3krgDLnIq4QmmZaZaU1FwD7f2FM=";
      "cosmic-text-0.11.2" = "sha256-TLPDnqixuW+aPAhiBhSvuZIa69vgV3xLcw32OlkdCcM=";
      "font-kit-0.14.1" = "sha256-qUKvmi+RDoyhMrZ7T6SoVAyMc/aasQ9Y/okzre4SzXo=";
      "lsp-types-0.95.1" = "sha256-N4MKoU9j1p/Xeowki/+XiNQPwIcTm9DgmfM/Eieq4js=";
      "nvim-rs-0.8.0-pre" = "sha256-VA8zIynflul1YKBlSxGCXCwa2Hz0pT3mH6OPsfS7Izo=";
      "protols-tree-sitter-proto-0.2.0" = "sha256-0pvHuwqtkHYLevQnaEFmfyDtILD7Wy0in2KSKFR2mKw=";
      "tree-sitter-gomod-1.0.2" = "sha256-FCb8ndKSFiLY7/nTX7tWF8c4KcSvoBU1QB5R4rdOgT0=";
      "tree-sitter-gowork-0.0.1" = "sha256-WRMgGjOlJ+bT/YnSBeSLRTLlltA5WwTvV0Ow/949+BE=";
      "tree-sitter-heex-0.0.1" = "sha256-SnjhL0WVsHOKuUp3dkTETnCgC/Z7WN0XmpQdJPBeBhw=";
      "tree-sitter-md-0.3.2" = "sha256-sFcQDabSay9qxzVNAQkHEZB1b9j171dDoYQqaL1iVhE=";
      "tree-sitter-yaml-0.6.1" = "sha256-95u/bq74SiUHW8lVp3RpanmYS/lyVPW0Inn8gR7N3IQ=";
      "xim-0.4.0" = "sha256-BXyaIBoqMNbzaSJqMadmofdjtlEVSoU6iogF66YP6a4=";
      "xkbcommon-0.7.0" = "sha256-2RjZWiAaz8apYTrZ82qqH4Gv20WyCtPT+ldOzm0GWMo=";
    };
  };

  nativeBuildInputs = [
    clang
    cmake
    copyDesktopItems
    curl
    perl
    pkg-config
    protobuf
    rustPlatform.bindgenHook
    cargo-about
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ xcbuild.xcrun ];

  dontUseCmakeConfigure = true;

  buildInputs =
    [
      curl
      fontconfig
      freetype
      libgit2
      openssl
      sqlite
      zlib
      zstd
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      alsa-lib
      libxkbcommon
      wayland
      xorg.libxcb
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        AppKit
        CoreAudio
        CoreFoundation
        CoreGraphics
        CoreMedia
        CoreServices
        CoreText
        Foundation
        IOKit
        Metal
        Security
        SystemConfiguration
        VideoToolbox
      ]
    );

  cargoBuildFlags = [
    "--package=zed"
    "--package=cli"
  ];
  buildFeatures = [ "gpui/runtime_shaders" ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
    FONTCONFIG_FILE = makeFontsConf {
      fontDirectories = [
        "${src}/assets/fonts/plex-mono"
        "${src}/assets/fonts/plex-sans"
      ];
    };
    # Setting this environment variable allows to disable auto-updates
    # https://zed.dev/docs/development/linux#notes-for-packaging-zed
    ZED_UPDATE_EXPLANATION = "zed has been installed using nix. Auto-updates have thus been disabled.";
    # Used by `zed --version`
    RELEASE_VERSION = version;
  };

  RUSTFLAGS = if withGLES then "--cfg gles" else "";
  gpu-lib = if withGLES then libglvnd else vulkan-loader;

  preBuild = ''
    bash script/generate-licenses
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --add-rpath ${gpu-lib}/lib $out/libexec/*
    patchelf --add-rpath ${wayland}/lib $out/libexec/*
  '';

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  checkFlags = lib.optionals stdenv.hostPlatform.isLinux [
    # Fails on certain hosts (including Hydra) for unclear reason
    "--skip=test_open_paths_action"

    # Flaky: unreliably fails on certain hosts (including Hydra)
    "--skip=zed::tests::test_window_edit_state_restoring_enabled"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/libexec
    cp target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/zed $out/libexec/zed-editor
    cp target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cli $out/bin/zeditor

    install -D ${src}/crates/zed/resources/app-icon@2x.png $out/share/icons/hicolor/1024x1024@2x/apps/zed.png
    install -D ${src}/crates/zed/resources/app-icon.png $out/share/icons/hicolor/512x512/apps/zed.png

    # extracted from https://github.com/zed-industries/zed/blob/v0.141.2/script/bundle-linux (envsubst)
    # and https://github.com/zed-industries/zed/blob/v0.141.2/script/install.sh (final desktop file name)
    (
      export DO_STARTUP_NOTIFY="true"
      export APP_CLI="zeditor"
      export APP_ICON="zed"
      export APP_NAME="Zed"
      export APP_ARGS="%U"
      mkdir -p "$out/share/applications"
      ${lib.getExe envsubst} < "crates/zed/resources/zed.desktop.in" > "$out/share/applications/dev.zed.Zed.desktop"
    )

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "v(.*)"
      ];
    };
    tests.version = testers.testVersion {
      inherit version;
      package = zed-editor;
    };
    fhs = fhs { };
    fhsWithPackages = f: fhs { additionalPkgs = f; };
  };

  meta = {
    description = "High-performance, multiplayer code editor from the creators of Atom and Tree-sitter";
    homepage = "https://zed.dev";
    changelog = "https://github.com/zed-industries/zed/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      GaetanLepage
      niklaskorz
    ];
    mainProgram = "zeditor";
    platforms = lib.platforms.all;
    # Currently broken on darwin: https://github.com/NixOS/nixpkgs/pull/303233#issuecomment-2048650618
    broken = stdenv.hostPlatform.isDarwin;
  };
}
