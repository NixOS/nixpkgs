{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-hostname";
  version = "0-unstable-2026-02-24";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "hostname";
    rev = "b5efd550762655d4483d70fbc54f5829a8f94a11";
    hash = "sha256-ipjI6E5x3ORr5H1YQA7NvoTk894fQWLiMdjnb7iaubc=";
  };

  cargoHash = "sha256-wR8nRDljztDLdxVFb2pdy4wfqw3zWj3mHUpKrAPCFrw=";

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
