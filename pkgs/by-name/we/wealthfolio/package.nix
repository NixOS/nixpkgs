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
  version = "3.10.0";

  src = fetchFromGitHub {
    owner = "wealthfolio";
    repo = "wealthfolio";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dwZaPQh9qA7KOl0pw3yKOl5uDBYy4YzaRpEA9e+1hOM=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) src pname version;
    pnpm = pnpm_10;
    fetcherVersion = 4;
    hash = "sha256-hRIe3OuIlvCsLbaIpurAHfTV/oA+mBWWsP8XPKGcE/0=";
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
    hash = "sha256-+ct0reGkqHytMdq+frEi+s5zvd0PdP0kR5Mqr3IrXVI=";
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
