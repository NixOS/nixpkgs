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
        hash = "sha256-9pINtZToPqAA5VRTO8lRIBzNxO9481WvMkE2kk/iyUM=";
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
    version = "3.5.3";

    src = fetchFromGitHub {
      owner = "wealthfolio";
      repo = "wealthfolio";
      tag = "v${finalAttrs.version}";
      hash = "sha256-9dE0IQtDUcveZk2eWu9+UDpAYPgk/LbY+jsTNH3N9hg=";
    };

    cargoRoot = ".";
    buildAndTestSubdir = "apps/server";
    cargoHash = "sha256-P93AAivBXWBLik8M/DNUWyKXVsq7ttvX3DpiXwaDL2I=";

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
