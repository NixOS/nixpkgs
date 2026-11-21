{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-hostname";
  version = "0-unstable-2026-11-12";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "hostname";
    rev = "6207059e914aca60a2746818e1b6db8eaa5469f1";
    hash = "sha256-DnXQSqpgrjCohY6e2n3AefTvL1hkXC7syk3X4AitLzY=";
  };

  cargoHash = "sha256-XP4eQBcLkGxTOyQqCXf/l7QiMUC0OjC0Y6JjBKElPqc=";

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
