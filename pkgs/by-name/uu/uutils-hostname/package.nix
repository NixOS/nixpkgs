{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-hostname";
  version = "0-unstable-2026-03-08";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "hostname";
    rev = "ecf119d03ab203ad828b4e48161f870dd704a503";
    hash = "sha256-ynGGk44Ildztqx956NJYvD5+1SBLCPjD8VsI7Nmcxrk=";
  };

  cargoHash = "sha256-K0TEsAWyDVfqMkRYuOaisI3k0S6IMYu4XzQTtvvx5XQ=";

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
