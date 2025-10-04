{
  lib,
  stdenv,
  fetchFromGitHub,
  cargo-tauri,
  jq,
  libsoup_3,
  moreutils,
  nodejs,
  openssl,
  pkg-config,
  pnpm_9,
  rustPlatform,
  webkitgtk_4_1,
  wrapGAppsHook3,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wealthfolio";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "afadil";
    repo = "wealthfolio";
    rev = "v${finalAttrs.version}";
    hash = "sha256-bp8BxJp/Ga9Frqyvl76Fh9AfSEKv3W+P1ND9zqeMXhg=";
  };

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) src pname version;
    fetcherVersion = 1;
    hash = "sha256-imExQiPl6sjYD//p788dGYEn+DRs9H8l9sGmCdl5Cic=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      cargoRoot
      ;
    hash = "sha256-CiEtxZn+kqYqS0sx9SLPvIkOTq2La48gQp+xx9z5BJs=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    jq
    moreutils
    nodejs
    pkg-config
    pnpm_9.configHook
    rustPlatform.cargoSetupHook
    wrapGAppsHook3
  ];

  buildInputs = [
    libsoup_3
    openssl
    webkitgtk_4_1
  ];

  postPatch = ''
    jq \
      '.plugins.updater.endpoints = [ ]
      | .bundle.createUpdaterArtifacts = false' \
      src-tauri/tauri.conf.json \
      | sponge src-tauri/tauri.conf.json
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Beautiful Private and Secure Desktop Investment Tracking Application";
    homepage = "https://wealthfolio.app/";
    license = lib.licenses.agpl3Only;
    mainProgram = "wealthfolio";
    maintainers = with lib.maintainers; [ kilianar ];
    platforms = lib.platforms.linux;
  };
})
