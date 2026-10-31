{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-hostname";
  version = "0-unstable-2026-10-17";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "hostname";
    rev = "a6e1a935775fcde6e781f3b73017287835b478a5";
    hash = "sha256-OLh6FbpeSxbpE+GAOLQBDtQSQnk45ZDIpO6fXZcMliU=";
  };

  cargoHash = "sha256-sc7k53UbYprdxO4ms+TlJoZYAX9ziYiKqh7iuC255KQ=";

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
