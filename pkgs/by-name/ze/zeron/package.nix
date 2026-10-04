{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  imagemagick,
  libicns,
  lld,
  versionCheckHook,
  nix-update-script,
  onnxruntime,
  oniguruma,
  openssl,
  alsa-lib,
  fontconfig,
  freetype,
  glib,
  gtk3,
  json-glib,
  libsoup_3,
  webkitgtk_4_1,
  libxkbcommon,
  wayland,
  libxcb,
  libx11,
  vulkan-loader,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zeron";
  version = "0.2.102";

  src = fetchFromGitHub {
    owner = "zeronsh";
    repo = "zeron";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ulvb5mFF6AvKl5UWhZ9+2tXXGUe91hgblSJKJU1QkJ4=";
  };

  cargoHash = "sha256-wcptalzdLxlimrVoEej8jRoyieMLevBp637t3Y1tKZA=";

  __structuredAttrs = true;

  postPatch = ''
    # The in-app updater swaps the binary or the .app bundle in place, which
    # cannot work from the read-only store. Treating every install as
    # "Unmanaged" keeps it report-only, the same path upstream uses for
    # source builds.
    substituteInPlace crates/update/src/lib.rs \
      --replace-fail \
        'pub fn detect_install() -> InstallKind {' \
        'pub fn detect_install() -> InstallKind {
    #[allow(unreachable_code)]
    return InstallKind::Unmanaged;'
  '';

  # No buildFeatures for the Metal shaders: the workspace already enables
  # gpui_platform/runtime_shaders, so the build never reaches for the
  # proprietary Metal compiler that zed-editor has to opt out of.
  cargoBuildFlags = [ "--package=zeron" ];

  nativeBuildInputs = [
    pkg-config
    imagemagick
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libicns
    lld
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    oniguruma
    openssl
    onnxruntime
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    fontconfig
    freetype
    glib
    gtk3
    # crates/ui/build.rs compiles a WebKitGTK helper embedded in the binary.
    json-glib
    libsoup_3
    webkitgtk_4_1
    libxkbcommon
    wayland
    libxcb
    libx11
  ];

  env = {
    # Installed binaries are stripped during fixup anyway.
    CARGO_PROFILE_RELEASE_DEBUG = "false";
    OPENSSL_NO_VENDOR = true;
    RUSTONIG_SYSTEM_LIBONIG = true;
    # ort-sys downloads a prebuilt onnxruntime unless pointed at a local one.
    ORT_LIB_LOCATION = "${lib.getLib onnxruntime}/lib";
    ORT_PREFER_DYNAMIC_LINK = true;
  }
  // lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    # Same as zed-editor: nixpkgs' ld64 fails to insert ARM64 branch thunks
    # for a gpui binary this size ("branch out of range").
    NIX_CFLAGS_LINK = "-fuse-ld=lld";
  };

  # Most tests need a GPU, a display server, or network access.
  doCheck = false;

  installPhase = ''
    runHook preInstall

    release_target="target/${stdenv.hostPlatform.rust.cargoShortTarget}/release"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Mirrors scripts/package-macos.sh, minus code signing and notarization.
    app="$out/Applications/Zeron.app"
    install -Dm755 $release_target/zeron "$app/Contents/MacOS/zeron"
    sed "s/__VERSION__/${finalAttrs.version}/" dist/macos/Info.plist > "$app/Contents/Info.plist"

    # sips/iconutil are unavailable in the sandbox; png2icns builds the same
    # icns from the pre-masked macOS artwork.
    iconset=$(mktemp -d)
    for size in 16 32 128 256 512; do
      magick dist/macos/icon-1024.png -resize ''${size}x''${size} "$iconset/icon_$size.png"
    done
    mkdir -p "$app/Contents/Resources"
    png2icns "$app/Contents/Resources/zeron.icns" "$iconset"/icon_*.png

    mkdir -p $out/bin
    ln -s "$app/Contents/MacOS/zeron" $out/bin/zeron
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm755 $release_target/zeron $out/bin/zeron
    install -Dm644 dist/zeron.desktop $out/share/applications/zeron.desktop
    install -Dm644 dist/zeron.svg $out/share/icons/hicolor/scalable/apps/zeron.svg
    for size in 128 256 512; do
      mkdir -p $out/share/icons/hicolor/''${size}x''${size}/apps
      magick dist/zeron.png -resize ''${size}x''${size} \
        $out/share/icons/hicolor/''${size}x''${size}/apps/zeron.png
    done
  ''
  + ''
    runHook postInstall
  '';

  # gpui and wgpu dlopen these at runtime, so they never land in DT_NEEDED.
  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf $out/bin/zeron --add-rpath ${
      lib.makeLibraryPath [
        vulkan-loader
        wayland
        libxkbcommon
      ]
    }
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Native control plane for Claude Code, Codex, Cursor and other coding agents";
    homepage = "https://zeron.sh";
    downloadPage = "https://github.com/zeronsh/zeron/releases";
    changelog = "https://github.com/zeronsh/zeron/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ imTHAI ];
    mainProgram = "zeron";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})
