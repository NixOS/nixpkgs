{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-hostname";
  version = "0-unstable-2026-02-10";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "hostname";
    rev = "217d1bce696197b13beab7a60dbb99609933a179";
    hash = "sha256-E50v5IQQNdBiejxrJPwnoBR/V3Qrm8eg+hki2qadlxQ=";
  };

  cargoHash = "sha256-aE/XXf+tIRSiiixdLmAxPgRVwBsbk4L2grwOFlydMx4=";

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
