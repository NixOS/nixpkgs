{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-tar";
  version = "0-unstable-2026-05-01";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "tar";
    rev = "1afcb449283cb1987a69a01c4c784bb3623e3550";
    hash = "sha256-Xitb3OGRSJQUZ6yiQLH7TE9UvKpClXrQGdLLDnE1/gg=";
  };

  cargoHash = "sha256-P0KPKriD4cWidWOApHWGIb80rCg5yk5Vub0IAyz5VUs=";

  cargoBuildFlags = [ "--workspace" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version=branch"
      "--version-regex=^(?!latest-commit.*)(.*)$"
    ];
  };

  meta = {
    description = "Rust implementation of tar";
    homepage = "https://github.com/uutils/tar";
    license = lib.licenses.mit;
    mainProgram = "tarapp";
    maintainers = with lib.maintainers; [ kyehn ];
    platforms = lib.platforms.unix;
  };
})
