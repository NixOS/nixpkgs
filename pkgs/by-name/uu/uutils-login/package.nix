{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-login";
  version = "0-unstable-2026-01-28";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "login";
    rev = "ec2c270122a4fdb5f7cae5d8ff5ae9c66018fb69";
    hash = "sha256-LqlxsztC+9XgCqErtTLt7lYcBKz9Ht7pvWLclptW834=";
  };

  cargoHash = "sha256-1Ph+vJeRTWYTfj2Qu74T7L8GpT1PiI1GKyOHTwo0HXA=";

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
