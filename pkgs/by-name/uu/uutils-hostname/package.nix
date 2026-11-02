{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-hostname";
  version = "0-unstable-2026-10-28";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "hostname";
    rev = "c4de07add34238b1dd577da17d03129b3f0940cf";
    hash = "sha256-Jvhzo346ydvF+20XLjCkynL2aMoTvFSi0xK/CYaA5y4=";
  };

  cargoHash = "sha256-QBEm8MneWUiWmB0xDOmAklzCs+WmzjNXKFR6ggXj3l8=";

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
