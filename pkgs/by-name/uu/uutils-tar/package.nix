{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-tar";
  version = "0-unstable-2026-02-17";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "tar";
    rev = "1dd0e21169bb23bf07daaabb9686bcae93944679";
    hash = "sha256-kMOwClmliGlIMX+fK7TCD5pczHANoziug2MDb5+Pqew=";
  };

  cargoHash = "sha256-s8BHAfc6L0RyK8xX8C2exjjOUAULt1xnrSkt4T/qruE=";

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
