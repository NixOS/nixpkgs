{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-hostname";
  version = "0-unstable-2026-04-23";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "hostname";
    rev = "85c60f53d980d6c4ff7c6b679a7b851cbf153703";
    hash = "sha256-BbCgtnfk5qVYAy0hKWnkV+p2tRIn//S4dK17eLsLXhk=";
  };

  cargoHash = "sha256-7lEWWqEh500f85Rh1INoEush8eSVMwnLbcCBOembqcA=";

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
