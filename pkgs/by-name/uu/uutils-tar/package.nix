{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-tar";
  version = "0.0.1-unstable-2026-01-08";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "tar";
    rev = "a73ac381d8fd78f8cb05236d26edfdae37a80ee3";
    hash = "sha256-b8Nzp5zZuULH5YkCexVOPxioPiuauGL4+KarBAdVAd4=";
  };

  cargoHash = "sha256-UFRe+dBQhsV91tenZY4uqw9gs4ZqbYDtvBeA98dk3po=";

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
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
