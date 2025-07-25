{
  lib,
  stdenv,
  fetchFromGitHub,
  alsa-lib,
  buildNpmPackage,
  cargo-tauri,
  dbip-country-lite,
  glib,
  libayatana-appindicator,
  nix-update-script,
  openssl,
  pkg-config,
  rustPlatform,
  webkitgtk_4_1,
}:
let
  version = "1.4.0-unstable-2025-05-18";

  src = fetchFromGitHub {
    owner = "openscopeproject";
    repo = "TrguiNG";
    rev = "d2cd93ecc724f196d93c701fa27afa4288d2a37c";
    hash = "sha256-Y3ZSpXmG+wi7x7qanKpRp917alssqF78L27Yt9K9Khs=";
  };

  meta = {
    description = "Remote GUI for Transmission torrent daemon";
    homepage = "https://github.com/openscopeproject/TrguiNG";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ ambroisie ];
  };

  frontend = buildNpmPackage (finalAttrs: {
    pname = "TrguiNG-frontend";
    inherit version src;
    npmDepsHash = "sha256-sHZHAlV3zVeCmVTlIr0NeS1zxRCKfRMv1w9bW0tOg3g=";

    npmBuildScript = "webpack-prod";

    installPhase = ''
      runHook preInstall

      cp -r dist/ $out

      runHook postInstall
    '';

    env.TRGUING_VERSION = finalAttrs.version;

    meta = meta // {
      description = "Web UI for Transmission torrent daemon";
    };
  });
in

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "TrguiNG";
  inherit version src;

  cargoHash = "sha256-TflzT1BNAciMcxcejrlmIOIjXc1tpm/zX0kjk+dpGiM=";

  postPatch = ''
    cp ${dbip-country-lite}/share/dbip/dbip-country-lite.mmdb src-tauri/dbip.mmdb

    # Copy pre-built frontend and remove `beforeBuildCommand` to build it
    cp -r ${finalAttrs.passthru.frontend} dist/
    substituteInPlace src-tauri/tauri.conf.json \
      --replace-fail '"npm run webpack-prod"' '""'
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
      --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
  '';

  nativeBuildInputs = [
    cargo-tauri.hook
    pkg-config
  ];

  buildInputs = [
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

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "-s"
        "frontend"
      ];
    };
    inherit frontend;
  };

  meta = meta // {
    mainProgram = "TrguiNG";
  };
})
