{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-tar";
  version = "0-unstable-2026-03-13";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "tar";
    rev = "7e18ede4faec578945692d8676fc0d18c595dfae";
    hash = "sha256-P53UMIXEYAQ88bHILokVH8I6VUDfxI921Y8aVo8QZPM=";
  };

  cargoHash = "sha256-X/Y4s7l9PeImnN+dVWsRyvzVHdvlIrWdYR88vAr2E0U=";

  cargoBuildFlags = [ "--workspace" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Rust implementation of tar";
    homepage = "https://github.com/uutils/tar";
    license = lib.licenses.mit;
    mainProgram = "tarapp";
    maintainers = with lib.maintainers; [ kyehn ];
    platforms = lib.platforms.unix;
  };
})
