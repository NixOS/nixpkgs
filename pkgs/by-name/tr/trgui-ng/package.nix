{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchNpmDeps,
  alsa-lib,
  cargo-tauri,
  dbip-country-lite,
  glib,
  libayatana-appindicator,
  nodejs,
  npmHooks,
  openssl,
  pkg-config,
  rustPlatform,
  webkitgtk_4_1,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "TrguiNG";
  version = "1.4.0-unstable-2025-05-18";

  src = fetchFromGitHub {
    owner = "openscopeproject";
    repo = "TrguiNG";
    rev = "d2cd93ecc724f196d93c701fa27afa4288d2a37c";
    hash = "sha256-Y3ZSpXmG+wi7x7qanKpRp917alssqF78L27Yt9K9Khs=";
  };

  cargoHash = "sha256-TflzT1BNAciMcxcejrlmIOIjXc1tpm/zX0kjk+dpGiM=";

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-npm-deps-${finalAttrs.version}";
    inherit (finalAttrs) src;
    hash = "sha256-sHZHAlV3zVeCmVTlIr0NeS1zxRCKfRMv1w9bW0tOg3g=";
  };

  postPatch =
    ''
      cp ${dbip-country-lite}/share/dbip/dbip-country-lite.mmdb src-tauri/dbip.mmdb
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
        --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
    '';

  env.TRGUING_VERSION = finalAttrs.version;

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    npmHooks.npmConfigHook
    pkg-config
  ];

  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      alsa-lib
      glib
      libayatana-appindicator
      webkitgtk_4_1
    ];

  cargoRoot = "src-tauri";
  buildAndTestSubdir = "src-tauri";

  meta = {
    description = "Remote GUI for Transmission torrent daemon";
    homepage = "https://github.com/openscopeproject/TrguiNG";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ ambroisie ];
    mainProgram = "TrguiNG";
  };
})
