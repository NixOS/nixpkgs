{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchzip,
  fetchpatch,
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
  libGL,
  libX11,
  libXext,
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
  version = "0.150.0-unstable-2024-08-16";

  src = fetchFromGitHub {
    owner = "zed-industries";
    repo = "zed";
    #rev = "refs/tags/v${version}";
    # https://github.com/zed-industries/zed/pull/13343
    rev = "48b4c3ef418aea8086f7f00d0697252de6c1f257";
    hash = "sha256-OCOpIPc5x7a252iYTJIkCOUNFdG3HQqtQ/BTuPNZ3Y8=";
  };

  patches = [
    (fetchpatch {
      name = "0001-Override-cpal-to-ensure-that-the-same-version-is-use.patch";
      url = "https://github.com/user-attachments/files/16644162/0001-Override-cpal-to-ensure-that-the-same-version-is-use.patch";
      hash = "sha256-P/0Nv4PfCfP1SuFyGioSPKYQs0jyvSnNrEMvUZj4vaU=";
    })
  ];

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "alacritty_terminal-0.24.1-dev" = "sha256-aVB1CNOLjNh6AtvdbomODNrk00Md8yz8QzldzvDo1LI=";
      "async-pipe-0.1.3" = "sha256-g120X88HGT8P6GNCrzpS5SutALx5H+45Sf4iSSxzctE=";
      "blade-graphics-0.4.0" = "sha256-sGXhXmgtd7Wx/Gf7HCWro4RsQOGS4pQt8+S3T+2wMfY=";
      "cosmic-text-0.11.2" = "sha256-TLPDnqixuW+aPAhiBhSvuZIa69vgV3xLcw32OlkdCcM=";
      "cpal-0.15.3" = "sha256-t+jY+0gygP+4ZHbWc40o2i+A4tLXjwKYEwS6cPvujes=";
      "font-kit-0.14.1" = "sha256-qUKvmi+RDoyhMrZ7T6SoVAyMc/aasQ9Y/okzre4SzXo=";
      "libwebrtc-0.3.4" = "sha256-z6yyC4uMmZrP3ZjpbRtYLb6EkvzMftjLnISmRdgplzA=";
      "lsp-types-0.95.1" = "sha256-N4MKoU9j1p/Xeowki/+XiNQPwIcTm9DgmfM/Eieq4js=";
      "nvim-rs-0.8.0-pre" = "sha256-VA8zIynflul1YKBlSxGCXCwa2Hz0pT3mH6OPsfS7Izo=";
      "tree-sitter-0.22.6" = "sha256-P9pQcofDCIhOYWA1OC8TzB5UgWpD5GlDzX2DOS8SsH0=";
      "tree-sitter-gomod-1.0.2" = "sha256-/sjC117YAFniFws4F/8+Q5Wrd4l4v4nBUaO9IdkixSE=";
      "tree-sitter-gowork-0.0.1" = "sha256-803ujH5qwejQ2vQDDpma4JDC9a+vFX8ZQmr+77VyL2M=";
      "tree-sitter-heex-0.0.1" = "sha256-VakMZtWQ/h7dNy5ehk2Bh14a5s878AUgwY3Ipq8tPec=";
      "tree-sitter-md-0.2.3" = "sha256-Fa73P1h5GvKV3SxXr0KzHuNp4xa5wxUzI8ecXbGdrYE=";
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
      # required by livekit:
      libGL
      libX11
      libXext
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
      webrtc_tag = "webrtc-dac8015-3";
      webrtc_os = if stdenv.isDarwin then "mac" else "linux";
      webrtc_arch = if stdenv.isAarch64 then "arm64" else "x64";
      webrtc_target = "${webrtc_os}-${webrtc_arch}";
    in
    fetchzip {
      url = "https://github.com/livekit/client-sdk-rust/releases/download/${webrtc_tag}/webrtc-${webrtc_target}-release.zip";
      hash =
        {
          "linux-arm64" = "sha256-L0ZGBFMWzKlJrK1wFW9CAekWHQg8Jr6x/jgbmt70RN8=";
          "linux-x64" = "sha256-jltjra7EuM66xJCl6yzcOgIKAeioaIxFeYf3ZTaI2rk=";
          "mac-arm64" = "sha256-cPHdgoHbiBD/Q0p0LAYF8z91QEKPJyH9R/ZlJVJx4U8=";
          "mac-x64" = "sha256-Bnp50g+wpHD9GR3RdAdHzEDaBn0ya/ayRT94emLMwpw=";
        }
        .${webrtc_target};
    };

  RUSTFLAGS = if withGLES then "--cfg gles" else "";
  gpu-lib = if withGLES then libglvnd else vulkan-loader;

  postFixup = lib.optionalString stdenv.isLinux ''
    patchelf --add-rpath ${gpu-lib}/lib $out/libexec/*
    patchelf --add-rpath ${wayland}/lib $out/libexec/*
  '';

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  checkFlags =
    [
      # Flaky: unreliably fails on certain hosts (including Hydra)
      "--skip=zed::tests::test_window_edit_state_restoring_enabled"
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
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
