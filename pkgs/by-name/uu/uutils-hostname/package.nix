{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-hostname";
  version = "0.0.1-unstable-2026-01-08";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "hostname";
    rev = "a5590e823e2cb488ad14f61dee92e04cb4dc2704";
    hash = "sha256-nWRkqONxbSwhphULpM+m14H/DSPmM4XdLJ7q2D4kooo=";
  };

  cargoHash = "sha256-1H4h01IqLVZrXNjnI36lGgsmg8rxHDAn9sbuvUxqPEQ=";

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Rust reimplementation of the hostname project";
    homepage = "https://github.com/uutils/hostname";
    license = lib.licenses.mit;
    mainProgram = "hostname";
    maintainers = with lib.maintainers; [ kyehn ];
    platforms = lib.platforms.unix;
  };
})
