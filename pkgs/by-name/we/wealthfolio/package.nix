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
  version = "3.5.2";

  src = fetchFromGitHub {
    owner = "afadil";
    repo = "wealthfolio";
    rev = "v${finalAttrs.version}";
    hash = "sha256-WU87VmnbzUno1CmIVwBLYjmTZybM4qSuRmBH/2n/Tfo=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) src pname version;
    pnpm = pnpm_10;
    fetcherVersion = 4;
    hash = "sha256-EDnHlaW3Ad32N8wl38ryo6pYvKU2T1OH6IkOuTLI7Vs=";
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
    hash = "sha256-KoS2EouZ0Uf3cijUUOpwYBYEjEB5VxIArU1CuCji2+I=";
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
    mainProgram = "wealthfolio";
    maintainers = with lib.maintainers; [ kilianar ];
    platforms = lib.platforms.linux;
  };
})
