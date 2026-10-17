{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-hostname";
  version = "0-unstable-2026-10-03";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "hostname";
    rev = "f92ca23956382e6a2d29e241a235ad6559687a5c";
    hash = "sha256-2oyccswFW77o1qAef+ew3kUifTGF5+8T+vdx7znCZCg=";
  };

  cargoHash = "sha256-E7tqeJ0F1QjhVNYB8OR6MBMhtpL0XQPpw4N8e6scmR8=";

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
