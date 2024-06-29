{
  lib,
  rustPlatform,
  fetchFromGitHub,
  clang,
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

  withGLES ? false,
}:

assert withGLES -> stdenv.isLinux;

rustPlatform.buildRustPackage rec {
  pname = "zed";
  version = "0.141.3";

  src = fetchFromGitHub {
    owner = "zed-industries";
    repo = "zed";
    rev = "refs/tags/v${version}";
    hash = "sha256-D4wVHMNy7xESuEORULyKf3ZxFfRSKfWEXjBnjh3yBVU=";
    fetchSubmodules = true;
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "alacritty_terminal-0.24.1-dev" = "sha256-aVB1CNOLjNh6AtvdbomODNrk00Md8yz8QzldzvDo1LI=";
      "async-pipe-0.1.3" = "sha256-g120X88HGT8P6GNCrzpS5SutALx5H+45Sf4iSSxzctE=";
      "blade-graphics-0.4.0" = "sha256-khJke3tIO8V7tT3MBk9vQhBKTiJEWTY6Qr4vzeuKnOk=";
      "cosmic-text-0.11.2" = "sha256-TLPDnqixuW+aPAhiBhSvuZIa69vgV3xLcw32OlkdCcM=";
      "font-kit-0.11.0" = "sha256-+4zMzjFyMS60HfLMEXGfXqKn6P+pOngLA45udV09DM8=";
      "lsp-types-0.95.1" = "sha256-N4MKoU9j1p/Xeowki/+XiNQPwIcTm9DgmfM/Eieq4js=";
      "nvim-rs-0.6.0-pre" = "sha256-bdWWuCsBv01mnPA5e5zRpq48BgOqaqIcAu+b7y1NnM8=";
      "pathfinder_simd-0.5.3" = "sha256-bakBcAQZJdHQPXybe0zoMzE49aOHENQY7/ZWZUMt+pM=";
      "tree-sitter-0.20.100" = "sha256-xZDWAjNIhWC2n39H7jJdKDgyE/J6+MAVSa8dHtZ6CLE=";
      "tree-sitter-go-0.20.0" = "sha256-/mE21JSa3LWEiOgYPJcq0FYzTbBuNwp9JdZTZqmDIUU=";
      "tree-sitter-gowork-0.0.1" = "sha256-lM4L4Ap/c8uCr4xUw9+l/vaGb3FxxnuZI0+xKYFDPVg=";
      "tree-sitter-heex-0.0.1" = "sha256-6LREyZhdTDt3YHVRPDyqCaDXqcsPlHOoMFDb2B3+3xM=";
      "tree-sitter-jsdoc-0.20.0" = "sha256-fKscFhgZ/BQnYnE5EwurFZgiE//O0WagRIHVtDyes/Y=";
      "tree-sitter-markdown-0.0.1" = "sha256-F8VVd7yYa4nCrj/HEC13BTC7lkV3XSb2Z3BNi/VfSbs=";
      "tree-sitter-proto-0.0.2" = "sha256-W0diP2ByAXYrc7Mu/sbqST6lgVIyHeSBmH7/y/X3NhU=";
      "xim-0.4.0" = "sha256-vxu3tjkzGeoRUj7vyP0vDGI7fweX8Drgy9hwOUOEQIA=";
    };
  };

  nativeBuildInputs = [
    clang
    copyDesktopItems
    curl
    perl
    pkg-config
    protobuf
    rustPlatform.bindgenHook
  ] ++ lib.optionals stdenv.isDarwin [ xcbuild.xcrun ];

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
    ++ lib.optionals stdenv.isLinux [
      alsa-lib
      libxkbcommon
      wayland
      xorg.libxcb
    ]
    ++ lib.optionals stdenv.isDarwin (
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

  buildFeatures = [ "gpui/runtime_shaders" ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
    FONTCONFIG_FILE = makeFontsConf {
      fontDirectories = [
        "${src}/assets/fonts/zed-mono"
        "${src}/assets/fonts/zed-sans"
      ];
    };
  };

  RUSTFLAGS = if withGLES then "--cfg gles" else "";
  gpu-lib = if withGLES then libglvnd else vulkan-loader;

  postFixup = lib.optionalString stdenv.isLinux ''
    patchelf --add-rpath ${gpu-lib}/lib $out/bin/*
    patchelf --add-rpath ${wayland}/lib $out/bin/*
  '';

  checkFlags = lib.optionals stdenv.hostPlatform.isLinux [
    # Fails on certain hosts (including Hydra) for unclear reason
    "--skip=test_open_paths_action"
  ];

  postInstall = ''
    install -D ${src}/crates/zed/resources/app-icon@2x.png $out/share/icons/hicolor/1024x1024@2x/apps/zed.png
    install -D ${src}/crates/zed/resources/app-icon.png $out/share/icons/hicolor/512x512/apps/zed.png

    # extracted from https://github.com/zed-industries/zed/blob/v0.141.2/script/bundle-linux
    (
      export DO_STARTUP_NOTIFY="true"
      export APP_CLI="zed"
      export APP_ICON="zed"
      export APP_NAME="Zed"
      mkdir -p "$out/share/applications"
      ${lib.getExe envsubst} < "crates/zed/resources/zed.desktop.in" > "$out/share/applications/zed.desktop"
    )
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "v(.*)"
    ];
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
    mainProgram = "zed";
    platforms = lib.platforms.all;
    # Currently broken on darwin: https://github.com/NixOS/nixpkgs/pull/303233#issuecomment-2048650618
    broken = stdenv.isDarwin;
  };
}
