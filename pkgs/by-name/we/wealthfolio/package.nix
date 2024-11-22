{
  lib,
  stdenv,
  fetchFromGitHub,
  cargo-tauri_1,
  libsoup,
  nodejs,
  openssl,
  pkg-config,
  pnpm,
  rustPlatform,
  webkitgtk_4_0,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wealthfolio";
  version = "1.0.18";

  src = fetchFromGitHub {
    owner = "afadil";
    repo = "wealthfolio";
    rev = "v${finalAttrs.version}";
    hash = "sha256-AH0bwzsnGaGE82Ds1pDeZkVY2GXEB7RqHYw+WAt69/4=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) src pname version;
    hash = "sha256-OpQg/ZZ4M2vszMZeCJAKzqGduxexZfIVe3Jy/hG3Yu0=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) pname version src;
    sourceRoot = "${finalAttrs.src.name}/${finalAttrs.cargoRoot}";
    hash = "sha256-jbdshb+Kjnh/yKQlCVaYT3/RQ6Zyo2dm72EToLsbqxc=";
  };

  nativeBuildInputs = [
    cargo-tauri_1.hook
    nodejs
    pkg-config
    pnpm.configHook
    rustPlatform.cargoSetupHook
    wrapGAppsHook3
  ];

  buildInputs = [
    libsoup
    openssl
    webkitgtk_4_0
  ];

  meta = {
    description = "A Beautiful Private and Secure Desktop Investment Tracking Application";
    homepage = "https://wealthfolio.app/";
    license = lib.licenses.agpl3Only;
    mainProgram = "wealthfolio";
    maintainers = with lib.maintainers; [ kilianar ];
    platforms = lib.platforms.linux;
  };
})
