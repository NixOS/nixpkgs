{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-hostname";
  version = "0-unstable-2026-06-21";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "hostname";
    rev = "f5a208d6ee8d5346270dcf8921479a555b9350ac";
    hash = "sha256-TiIxymwsQ8+DSfCPlUp4p444ybqyz+Q4880vgZwbtM4=";
  };

  cargoHash = "sha256-/TTPyB8qGEoOy/+qv+seQDmZG8UBCKI7qpbc9azd1g0=";

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
