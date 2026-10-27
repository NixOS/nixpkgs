{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchNpmDeps,
  cargo-tauri,
  nodejs,
  npmHooks,
  pkg-config,
  libx11,
  libayatana-appindicator,
  dbus,
  glib,
  gtk3,
  libsoup_3,
  webkitgtk_4_1,
  wrapGAppsHook3,
  gst_all_1,
  emscripten,
  python3,
  git,
  cacert,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tine-outliner";
  version = "0.9.2";

  # This setting disables the internal check for updates entirely
  # https://github.com/martinkoutecky/tine/tree/v0.9.0#packaging-tine-for-a-distribution
  env = {
    TINE_PACKAGED_BY = "Nixpkgs";
    # This makes sure our emcc is used
    TINE_PDFJS_EMCC = "emcc";
  };

  buildFeatures = [ "custom-protocol" ];

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "martinkoutecky";
    repo = "tine";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Bz+G8+q9WTQ9tU9njKQ4/jyPLc45PacqUi/D43e2l9Y=";
  };

  cargoHash = "sha256-xdDNhkZ5s7Gs2cWnO700kMndAb6/tAQT6LJa4mlgieY=";

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-YmqtXPu7kMY4tL3HCqCP3Wp3TLNLHxWHiT5MHqeCXek=";
  };

  preBuild = ''
    export EM_CACHE=$TMPDIR/emscripten-cache
  '';

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    npmHooks.npmConfigHook
    pkg-config
    wrapGAppsHook3
    emscripten
  ];

  nativeCheckInputs = [
    python3
    git
    cacert
    openssl
  ];

  buildInputs = [
    libx11
    dbus
    glib
    gtk3
    libsoup_3
    webkitgtk_4_1
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    libayatana-appindicator
  ];

  buildAndTestSubdir = "src-tauri";

  tauriBuildFlags = [
    "--config"
    (builtins.toJSON { bundle.createUpdaterArtifacts = false; })
  ];

  meta = {
    description = "Fast, local, Logseq-compatible outliner";
    homepage = "https://github.com/martinkoutecky/tine";
    changelog = "https://github.com/martinkoutecky/tine/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    mainProgram = "tine";
    maintainers = with lib.maintainers; [
      fcosanabria
      georgkrause
    ];
    platforms = lib.platforms.linux;
    sourceProvenance = [
      lib.sourceTypes.fromSource
      lib.sourceTypes.binaryBytecode
    ];
  };
})
