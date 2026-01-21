{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-login";
  version = "0.0.1-unstable-2026-01-08";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "login";
    rev = "24c158ef78ef8e769337a91c563223a1bf1b58a7";
    hash = "sha256-1pJhFtY3zJTDIKX9SXuv3yfrvPMNCiC/b7WKdBU1Nqk=";
  };

  cargoHash = "sha256-V0Cb3Vz3MpVxqaHpIxrfYD+EAjjQ0jKI9Qc6pN13deg=";

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
