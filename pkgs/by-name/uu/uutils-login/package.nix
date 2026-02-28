{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-login";
  version = "0-unstable-2026-02-24";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "login";
    rev = "85c14bdfff7668421c1b59bbab7ed9046bf9a5de";
    hash = "sha256-ntqv4Woc7X4jrw4/LUG2nOEhaBtTQh0wEFV97Jaan14=";
  };

  cargoHash = "sha256-uACq1EnUs3fbV2x8QGYx1mKCr+rWfzNOgFx5eJi8cQ4=";

  cargoBuildFlags = [ "--workspace" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Rust reimplemtation of the login project";
    homepage = "https://github.com/uutils/login";
    license = lib.licenses.mit;
    mainProgram = "shadow";
    maintainers = with lib.maintainers; [ kyehn ];
    platforms = lib.platforms.unix;
  };
})
