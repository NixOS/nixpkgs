{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchPnpmDeps,
  cargo-tauri,
  nodejs,
  pnpm_10,
  pnpmConfigHook,
  wrapGAppsHook4,
  webkitgtk_4_1,
  pkg-config,
  openssl,
  nix-update-script,
}:
let
  pnpm = pnpm_10;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tabularis";
  version = "0.22.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "TabularisDB";
    repo = "tabularis";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RXkyhgicrUCuQ0Ei4mnBwPwSAEtmWA35kVn9oGQEYX0=";
  };

  strictDeps = true;

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  cargoHash = "sha256-z3dMc9mnBfyjsSVWh/7nQWmogndl/bfrbvuz7X0JIMM=";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-pvocyG5wDCqpokUcYp3yoiOMK+Cbg2xKlYj0W1CtPME=";
  };

  postPatch = ''
    substituteInPlace src-tauri/tauri.conf.json \
      --replace-fail '"createUpdaterArtifacts": true' '"createUpdaterArtifacts": false'
  '';

  nativeBuildInputs = [
    cargo-tauri.hook

    nodejs
    pnpmConfigHook
    pnpm

    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ wrapGAppsHook4 ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    webkitgtk_4_1
  ];

  checkFlags = [
    "--skip=pool_manager_tests::postgres_tls_connector_tests::test_tls_connector_verify_full"
  ];

  env.OPENSSL_NO_VENDOR = 1;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lightweight, developer-focused database management tool, built with Tauri and React";
    homepage = "http://tabularis.dev";
    changelog = "https://github.com/TabularisDB/tabularis/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    inherit (cargo-tauri.hook.meta) platforms;
    maintainers = with lib.maintainers; [ nartsiss ];
    mainProgram = "tabularis";
  };
})
