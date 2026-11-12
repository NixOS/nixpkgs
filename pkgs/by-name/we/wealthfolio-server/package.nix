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
  pkg-config,
  openssl,
  cacert,
  aws-lc,
  sqlcipher,
  zstd,
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
        hash = "sha256-dANScS7oUFj5+f+q1R+mGkl+OTQO1h6TwuFhLgitq0Q=";
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
    version = "3.12.0";

    src = fetchFromGitHub {
      owner = "wealthfolio";
      repo = "wealthfolio";
      tag = "v${finalAttrs.version}";
      hash = "sha256-Z89ZF/BTa6fU/Ogi5V4KhDDlcHKQHIOhUv5if9QrPB8=";
    };

    cargoRoot = ".";
    buildAndTestSubdir = "apps/server";
    cargoHash = "sha256-IoKuEkgVju7+f6kFvtQPU9dAulBk4bjtfcN3jmdm384=";

    env = {
      OPENSSL_NO_VENDOR = 1;
      SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
    };

    nativeBuildInputs = [
      makeWrapper
      pkg-config
    ];

    buildInputs = [
      openssl
      aws-lc
      sqlcipher
      zstd
    ];

    postPatch = ''
      # The configuration tests intentionally wipe the environment to simulate a blank slate.
      # This strips Nix's injected SSL_CERT_FILE. We use sed to patch the test files
      # so that whenever they clear the environment, they immediately re-inject the cert path.
      find apps/server/tests -type f -name "*.rs" -exec sed -i \
        -e 's/\.env_clear()/.env_clear().env("SSL_CERT_FILE", std::env::var("SSL_CERT_FILE").unwrap_or_default())/g' \
        {} +
    '';

    postInstall = ''
      mkdir -p $out/share/wealthfolio/dist

      cp -R ${frontend}/* $out/share/wealthfolio/dist/

      wrapProgram $out/bin/wealthfolio-server \
        --set WF_STATIC_DIR "$out/share/wealthfolio/dist"
    '';

    passthru = {
      inherit frontend;
      updateScript = ./update.sh;
    };

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
