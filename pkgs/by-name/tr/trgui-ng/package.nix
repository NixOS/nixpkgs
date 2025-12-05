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
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "openscopeproject";
    repo = "TrguiNG";
    tag = "v${version}";
    hash = "sha256-N049HA+X9DcXyhmFbnxjfbQoKlf3dA73c1IOYFrDgwc=";
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
    npmDepsHash = "sha256-Ql1/itjEfvYigUzEZDWsGgJj7oZ1p6Bo00eLHRVHi4c=";

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

  cargoHash = "sha256-YGBLAO8lFvbowbT3yt2m/OQrpGzWghtyyZQJeYVQijA=";

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
