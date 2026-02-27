{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-hostname";
  version = "0-unstable-2026-02-17";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "hostname";
    rev = "c047799a57c09ee3878d78dc9134248747e6f677";
    hash = "sha256-41+QCRWJ1kUDkGxuTs8M+l96VhPtq25VPEqI58Arn7A=";
  };

  cargoHash = "sha256-gt1cC06Viu0trXL1+0/EToybSAJwFL3KVSltqUtpGj0=";

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
