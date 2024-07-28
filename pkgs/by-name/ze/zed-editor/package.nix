{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchzip,
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
  cargo-bundle,
  git,

  withGLES ? false,
}:

assert withGLES -> stdenv.isLinux;

rustPlatform.buildRustPackage rec {
  pname = "zed";
  version = "0.145.0";

  src = fetchFromGitHub {
    owner = "zed-industries";
    repo = "zed";
    # https://github.com/zed-industries/zed/pull/13343
    rev = "dcc24b0f97d1ed4aa093d3b3ccd6a4fa6709132e";
    hash = "sha256-pJ1pJZoI0rliIDoRskj/YDb28S719+7eeQECEukzD3w=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "alacritty_terminal-0.24.1-dev" = "sha256-aVB1CNOLjNh6AtvdbomODNrk00Md8yz8QzldzvDo1LI=";
      "async-pipe-0.1.3" = "sha256-g120X88HGT8P6GNCrzpS5SutALx5H+45Sf4iSSxzctE=";
      "blade-graphics-0.4.0" = "sha256-c0KhzG/FCpAyiafGZTbxDMz1ktCTURNDxO3fkB16nUw=";
      "cosmic-text-0.11.2" = "sha256-TLPDnqixuW+aPAhiBhSvuZIa69vgV3xLcw32OlkdCcM=";
      "cpal-0.15.3" = "sha256-t+jY+0gygP+4ZHbWc40o2i+A4tLXjwKYEwS6cPvujes=";
      "font-kit-0.11.0" = "sha256-+4zMzjFyMS60HfLMEXGfXqKn6P+pOngLA45udV09DM8=";
      "libwebrtc-0.3.4" = "sha256-LmRBbFeui7rVkjHAfzZWa3abljyZ+TqfhisK72DN7oY=";
      "lsp-types-0.95.1" = "sha256-N4MKoU9j1p/Xeowki/+XiNQPwIcTm9DgmfM/Eieq4js=";
      "naga-0.20.0" = "sha256-07lLKQLfWYyOwWmvzFQ0vMeuC5pxmclz6Ub72ooSmwk=";
      "nvim-rs-0.6.0-pre" = "sha256-bdWWuCsBv01mnPA5e5zRpq48BgOqaqIcAu+b7y1NnM8=";
      "pathfinder_simd-0.5.3" = "sha256-94/qS5d0UKYXAdx+Lswj6clOTuuK2yxqWuhpYZ8x1nI=";
      "tree-sitter-0.20.100" = "sha256-xZDWAjNIhWC2n39H7jJdKDgyE/J6+MAVSa8dHtZ6CLE=";
      "tree-sitter-go-0.20.0" = "sha256-/mE21JSa3LWEiOgYPJcq0FYzTbBuNwp9JdZTZqmDIUU=";
      "tree-sitter-gowork-0.0.1" = "sha256-lM4L4Ap/c8uCr4xUw9+l/vaGb3FxxnuZI0+xKYFDPVg=";
      "tree-sitter-heex-0.0.1" = "sha256-6LREyZhdTDt3YHVRPDyqCaDXqcsPlHOoMFDb2B3+3xM=";
      "tree-sitter-jsdoc-0.20.0" = "sha256-fKscFhgZ/BQnYnE5EwurFZgiE//O0WagRIHVtDyes/Y=";
      "tree-sitter-markdown-0.0.1" = "sha256-F8VVd7yYa4nCrj/HEC13BTC7lkV3XSb2Z3BNi/VfSbs=";
      "tree-sitter-proto-0.0.2" = "sha256-W0diP2ByAXYrc7Mu/sbqST6lgVIyHeSBmH7/y/X3NhU=";
      "xim-0.4.0" = "sha256-vxu3tjkzGeoRUj7vyP0vDGI7fweX8Drgy9hwOUOEQIA=";
      "xkbcommon-0.7.0" = "sha256-2RjZWiAaz8apYTrZ82qqH4Gv20WyCtPT+ldOzm0GWMo=";
    };
  };

  nativeBuildInputs =
    [
      clang
      copyDesktopItems
      curl
      perl
      pkg-config
      protobuf
      rustPlatform.bindgenHook
    ]
    ++ lib.optionals stdenv.isDarwin [
      xcbuild.xcrun
      cargo-bundle
    ];

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
      (with darwin.apple_sdk.frameworks; [
        AppKit
        AVFoundation
        CoreAudio
        CoreFoundation
        CoreGraphics
        CoreMedia
        CoreServices
        CoreText
        Foundation
        # fails to build if imported from 12.3 SDK
        IOKit
        Metal
        MetalKit
        ReplayKit
        Security
        System
        SystemConfiguration
      ])
      # The overrideSDK pattern as described in https://discourse.nixos.org/t/darwin-updates-news/42249/14
      # does not work here as ScreenCaptureKit is not contained in the unversioned frameworks.
      # It would also currently break IOKit.
      ++ (with darwin.apple_sdk_12_3.frameworks; [
        # introduced in 12.3
        ScreenCaptureKit
        # Zed needs latency control from VideoToolbox, available from 11.3+
        VideoToolbox
      ])
    );

  cargoBuildFlags = [
    "--package=zed"
    "--package=cli"
  ];
  # Required on darwin because we don't have access to the
  # proprietary Metal shader compiler.
  buildFeatures = lib.optionals stdenv.isDarwin [ "gpui/runtime_shaders" ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
    FONTCONFIG_FILE = makeFontsConf {
      fontDirectories = [
        "${src}/assets/fonts/zed-mono"
        "${src}/assets/fonts/zed-sans"
      ];
    };
  };

  # TODO: can this be built from source?
  LK_CUSTOM_WEBRTC =
    let
      # Must match WEBRTC_TAG in https://github.com/livekit/rust-sdks/blob/v$VERSION/webrtc-sys/build/src/lib.rs
      # where $VERSION is the resolved version of libwebrtc in our ./Cargo.lock
      webrtc_tag = "webrtc-b951613-4";
      webrtc_os = if stdenv.isDarwin then "mac" else "linux";
      webrtc_arch = if stdenv.isAarch64 then "arm64" else "x64";
      webrtc_target = "${webrtc_os}-${webrtc_arch}";
    in
    fetchzip {
      url = "https://github.com/livekit/client-sdk-rust/releases/download/${webrtc_tag}/webrtc-${webrtc_target}-release.zip";
      hash =
        {
          "linux-arm64" = "sha256-s2bXdOGaTcXN6KI7hMWbV1Q9joGrKSbcrhQlyvRvtVo=";
          "linux-x64" = "sha256-F/e6eWvV3R7p0NlfijGBDMmfNpvk3qCcMM8Gf9d5YQ8=";
          "mac-arm64" = "sha256-RO15n3TQs0b9tnRdbqF7GoQ9H5orN3IduNBnG+BF3H4=";
          "mac-x64" = "sha256-vLKfw5ZsxhjG+tsw3hUeep2Sb0HaqmajgPkioi5Oyow=";
        }
        .${webrtc_target};
    };

  RUSTFLAGS = if withGLES then "--cfg gles" else "";
  gpu-lib = if withGLES then libglvnd else vulkan-loader;

  postFixup = lib.optionalString stdenv.isLinux ''
    patchelf --add-rpath ${gpu-lib}/lib $out/libexec/*
    patchelf --add-rpath ${wayland}/lib $out/libexec/*
  '';

  checkFlags = lib.optionals stdenv.hostPlatform.isLinux [
    # Fails on certain hosts (including Hydra) for unclear reason
    "--skip=test_open_paths_action"
  ];

  installPhase =
    if stdenv.isDarwin then
      ''
        runHook preInstall

        # cargo-bundle expects the binary in target/release
        mv target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/zed target/release/zed

        pushd crates/zed

        # Note that this is GNU sed, while Zed's bundle-mac uses BSD sed
        sed -i "s/package.metadata.bundle-stable/package.metadata.bundle/" Cargo.toml
        export CARGO_BUNDLE_SKIP_BUILD=true
        app_path=$(cargo bundle --release | xargs)

        # We're not using Zed's fork of cargo-bundle, so we must manually append their plist extensions
        # Remove closing tags from Info.plist (last two lines)
        head -n -2 $app_path/Contents/Info.plist > Info.plist
        # Append extensions
        cat resources/info/*.plist >> Info.plist
        # Add closing tags
        printf "</dict>\n</plist>\n" >> Info.plist
        mv Info.plist $app_path/Contents/Info.plist

        popd

        mkdir -p $out/Applications $out/bin
        # Zed expects git next to its own binary
        ln -s ${git}/bin/git $app_path/Contents/MacOS/git
        mv target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cli $app_path/Contents/MacOS/cli
        mv $app_path $out/Applications/

        # Physical location of the CLI must be inside the app bundle as this is used
        # to determine which app to start
        ln -s $out/Applications/Zed.app/Contents/MacOS/cli $out/bin/zed

        runHook postInstall
      ''
    else
      ''
        runHook preInstall

        mkdir -p $out/bin $out/libexec
        cp target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/zed $out/libexec/zed-editor
        cp target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cli $out/bin/zed

        install -D ${src}/crates/zed/resources/app-icon@2x.png $out/share/icons/hicolor/1024x1024@2x/apps/zed.png
        install -D ${src}/crates/zed/resources/app-icon.png $out/share/icons/hicolor/512x512/apps/zed.png

        # extracted from https://github.com/zed-industries/zed/blob/v0.141.2/script/bundle-linux (envsubst)
        # and https://github.com/zed-industries/zed/blob/v0.141.2/script/install.sh (final desktop file name)
        (
          export DO_STARTUP_NOTIFY="true"
          export APP_CLI="zed"
          export APP_ICON="zed"
          export APP_NAME="Zed"
          export APP_ARGS="%U"
          mkdir -p "$out/share/applications"
          ${lib.getExe envsubst} < "crates/zed/resources/zed.desktop.in" > "$out/share/applications/dev.zed.Zed.desktop"
        )

        runHook postInstall
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
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
