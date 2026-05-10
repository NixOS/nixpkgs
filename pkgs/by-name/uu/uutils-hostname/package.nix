{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-hostname";
  version = "0-unstable-2026-05-04";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "hostname";
    rev = "262c5678e98035b6211753eba669c6e5ba56e19a";
    hash = "sha256-SaJtJhkyKTuafm1EmJUgGX1L1etZHtMQJA3av7e6FsY=";
  };

  cargoHash = "sha256-Ml4yjnUOg3C0r7q5p425MsYdy0Qyz6JywzITUStcQfg=";

  cargoBuildFlags = [ "--package uu_hostname" ];

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
