{
  lib,
  stdenv,
  fetchFromGitHub,
  cargo-tauri,
  libsoup_3,
  nodejs,
  openssl,
  pkg-config,
  pnpm,
  rustPlatform,
  webkitgtk_4_1,
  wrapGAppsHook3,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wealthfolio";
  version = "1.0.22";

  src = fetchFromGitHub {
    owner = "afadil";
    repo = "wealthfolio";
    rev = "v${finalAttrs.version}";
    hash = "sha256-2g5zfRRxRm7/pCyut7weC4oTegwxCbvYpWSC2+qfcR8=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) src pname version;
    hash = "sha256-CNk4zysIIDzDxozCrUnsR63eme28mDsBkRVB/1tXnJI=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) pname version src;
    sourceRoot = "${finalAttrs.src.name}/${finalAttrs.cargoRoot}";
    hash = "sha256-569k7s6h8eJABNy2+xkNQegEXUhBOlX+zkf1pzNX3ZU=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    pkg-config
    pnpm.configHook
    rustPlatform.cargoSetupHook
    wrapGAppsHook3
  ];

  buildInputs = [
    libsoup_3
    openssl
    webkitgtk_4_1
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A Beautiful Private and Secure Desktop Investment Tracking Application";
    homepage = "https://wealthfolio.app/";
    license = lib.licenses.agpl3Only;
    mainProgram = "wealthfolio";
    maintainers = with lib.maintainers; [ kilianar ];
    platforms = lib.platforms.linux;
  };
})
