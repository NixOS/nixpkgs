{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-hostname";
  version = "0-unstable-2026-05-12";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "hostname";
    rev = "e249b7e976b31116b90531672e7b3e414d599345";
    hash = "sha256-SU/Tm8Q/+AKvf+O+tERGBlVMgifwByg6dQpZCcENYXo=";
  };

  cargoHash = "sha256-WlXYGvzbdcGb7qWB3L00oJpMZROmKq6zDrtSj6OwtYA=";

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
