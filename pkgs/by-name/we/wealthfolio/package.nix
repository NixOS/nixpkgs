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
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  rustPlatform,
  webkitgtk_4_1,
  wrapGAppsHook3,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "wealthfolio";
  version = "3.6.2";

  src = fetchFromGitHub {
    owner = "wealthfolio";
    repo = "wealthfolio";
    rev = "v${finalAttrs.version}";
    hash = "sha256-2Chwr7OifQ5PgRAnxDEeAxyYaxVQqS32mezqzUBKKyU=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) src pname version;
    pnpm = pnpm_10;
    fetcherVersion = 4;
    hash = "sha256-dpxUdXqRbYPwq/wKu8XFdcjhDSGYo5ory9rIovHGJwk=";
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
    hash = "sha256-pfUrfIZmuibjFYzcuh57WU/pTlXFZNWYgurNYn+Wvus=";
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
    libsoup_3
    openssl
    webkitgtk_4_1
  ];

  postPatch = ''
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
