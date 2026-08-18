{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-hostname";
  version = "0-unstable-2026-08-13";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "hostname";
    rev = "b2225a12d117b08ab675c3c6c5691843623b7c96";
    hash = "sha256-11rZ2ouja170U4XqnC35bIZQlCKiZx3mVs/z3scF6Fc=";
  };

  cargoHash = "sha256-2KrcR744d3UOc9uDOzjvn7ynm9h14mVtXvRmqjmRQh0=";

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
