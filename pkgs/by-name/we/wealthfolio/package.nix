{
  lib,
  stdenv,
  fetchFromGitHub,
  aws-lc,
  cargo-tauri,
  jq,
  libsoup_3,
  moreutils,
  nodejs,
  openssl,
  pkg-config,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  rustPlatform,
  sqlcipher,
  webkitgtk_4_1,
  wrapGAppsHook3,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "wealthfolio";
  version = "3.13.0";

  src = fetchFromGitHub {
    owner = "wealthfolio";
    repo = "wealthfolio";
    rev = "v${finalAttrs.version}";
    hash = "sha256-m8ndnxlZ2R2oR1Arxj8uF3VYKQDYx2bmAfTaIVyRiJE=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) src pname version;
    pnpm = pnpm_10;
    fetcherVersion = 4;
    hash = "sha256-ubPu/q2GflF4pdtudUqA+fHYF+8rto0xqO5Uj6lZadk=";
  };

  cargoRoot = ".";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      cargoRoot
      ;
    hash = "sha256-m94yMmYtBwrR3LMfSNf3IVmEKcvg+I00Hbe1ip28TE0=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    jq
    moreutils
    nodejs
    pkg-config
    pnpmConfigHook
    pnpm_10
    rustPlatform.cargoSetupHook
    wrapGAppsHook3
  ];

  buildInputs = [
    aws-lc
    libsoup_3
    openssl
    sqlcipher
    webkitgtk_4_1
  ];

  env.OPENSSL_NO_VENDOR = "1";

  postPatch = ''
    # Use the system CA certificates instead of the bundled Mozilla roots.
    substituteInPlace crates/http/src/lib.rs \
      --replace-fail \
        'reqwest::Client::builder().tls_certs_only(ROOTS.iter().cloned())' \
        'reqwest::Client::builder()'

    jq \
      '.plugins.updater.endpoints = [ ]
      | .bundle.createUpdaterArtifacts = false' \
      apps/tauri/tauri.conf.json \
      | sponge apps/tauri/tauri.conf.json
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Beautiful Private and Secure Desktop Investment Tracking Application";
    homepage = "https://wealthfolio.app/";
    license = lib.licenses.agpl3Only;
    mainProgram = "Wealthfolio";
    maintainers = with lib.maintainers; [ kilianar ];
    platforms = lib.platforms.linux;
  };
})
