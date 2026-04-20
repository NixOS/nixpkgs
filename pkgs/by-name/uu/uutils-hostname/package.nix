{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-hostname";
  version = "0-unstable-2026-04-16";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "hostname";
    rev = "467ce0be515b08f7f34680056c80063bcef4648d";
    hash = "sha256-+YAPk35CXBZUbIkgfRUhNLQCSrzovj/sWpQAMdBQUDU=";
  };

  cargoHash = "sha256-qcUXGPoc088kyoNjg4LdIAH88imnzq3v/RSeBwVFSv0=";

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
