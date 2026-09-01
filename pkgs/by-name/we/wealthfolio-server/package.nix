{
  lib,
  fetchFromGitHub,
  rustPlatform,
  fetchPnpmDeps,
  stdenv,
  pnpm_10,
  pnpmConfigHook,
  nodejs,
  makeWrapper,
}:

rustPlatform.buildRustPackage (
  finalAttrs:
  let
    frontendPname = "wealthfolio-frontend";

    frontend = stdenv.mkDerivation {
      pname = frontendPname;
      inherit (finalAttrs) version src;

      __structuredAttrs = true;
      strictDeps = true;

      pnpmDeps = fetchPnpmDeps {
        pname = frontendPname;
        inherit (finalAttrs) version src;

        pnpm = pnpm_10;
        fetcherVersion = 3;
        hash = "sha256-P7N2Y41W467PxEcg6EGBuEB1s6n7wfQh4Rg2Mv8z8bs=";
      };

      nativeBuildInputs = [
        nodejs
        pnpm_10
        pnpmConfigHook
      ];

      buildPhase = ''
        export BUILD_TARGET=web
        pnpm --filter frontend... build
      '';

      installPhase = ''
        mkdir -p $out
        cp -R dist/* $out/
      '';

      inherit (finalAttrs) meta;
    };
  in
  {
    __structuredAttrs = true;

    pname = "wealthfolio-server";
    version = "3.7.0";

    src = fetchFromGitHub {
      owner = "wealthfolio";
      repo = "wealthfolio";
      tag = "v${finalAttrs.version}";
      hash = "sha256-GsI2TrPXEiHKUnUxNNmYf2EveWlg5PJBGh5TYILK0yc=";
    };

    cargoRoot = ".";
    buildAndTestSubdir = "apps/server";
    cargoHash = "sha256-vnmhaAoF3O5N+y3HpYZz+2j/WU1HAA5uyKtxLCJBqA4=";

    nativeBuildInputs = [ makeWrapper ];

    postInstall = ''
      mkdir -p $out/share/wealthfolio/dist

      cp -R ${frontend}/* $out/share/wealthfolio/dist/

      wrapProgram $out/bin/wealthfolio-server \
        --set WF_STATIC_DIR "$out/share/wealthfolio/dist"
    '';

    meta = {
      description = "Self-hosted web app for Wealthfolio";
      homepage = "https://wealthfolio.app/";
      changelog = "https://github.com/wealthfolio/wealthfolio/tag/${finalAttrs.src.tag}";
      mainProgram = "wealthfolio-server";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ luuumine ];
      platforms = lib.platforms.linux;
    };
  }
)
