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
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tine-outliner";
  version = "0.8.4";

  buildFeatures = [ "custom-protocol" ];
  doCheck = false;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "martinkoutecky";
    repo = "tine";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Tl/2Tqhub8u2GNTSPM/h8AMUWYfo0P3WJkRRkBajUD4=";
  };

  cargoHash = "sha256-gCfDai3mxr2vf3kJy1n0WEp/q+08J4dHuN2Yz4h7Fuk=";

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-Yex79qbeeAW39mtNoD7z+DqxfZ+wpYGfHtxPStrUU3w=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    npmHooks.npmConfigHook
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = with gst_all_1; [
    libx11
    dbus
    glib
    gtk3
    libsoup_3
    webkitgtk_4_1
    gstreamer
    gst-plugins-base
    gst-plugins-good
    libayatana-appindicator
  ];

  buildAndTestSubdir = "src-tauri";

  tauriBuildFlags = [
    "--features"
    "custom-protocol"
    "--config"
    (builtins.toJSON { bundle.createUpdaterArtifacts = false; })
  ];

  meta = {
    description = "Fast, local, Logseq-compatible outliner";
    homepage = "https://github.com/martinkoutecky/tine";
    license = lib.licenses.agpl3Only;
    mainProgram = "tine";
    maintainers = with lib.maintainers; [
      fcosanabria
      georgkrause
    ];
    platforms = lib.platforms.linux;
  };
})
