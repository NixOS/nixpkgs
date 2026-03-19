{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-login";
  version = "0-unstable-2026-03-13";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "login";
    rev = "48edf37818d005a49fd3b90fd29aeb21a4bcc5da";
    hash = "sha256-cBpKoXgcEZcQWqOK2+yZnlWCWTTYK4z6PKgi4MDeOQk=";
  };

  cargoHash = "sha256-bvLQ6C6VySK/X+46kehOm5NOcgZnfQK9iz9cYbyPPu8=";

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
