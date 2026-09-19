{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-tar";
  version = "0-unstable-2026-09-18";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "tar";
    rev = "95cc92d49fc304b3087542899b29b049fd1e3945";
    hash = "sha256-Lqiodpl4KcXBKDBIGk4lbbrIdy2VgBbVEFDxGTDlO88=";
  };

  cargoHash = "sha256-kRSBSfrxzAnWrDS8s3P0MUHBJSiYGJTXTpKbHAW/zS8=";

  cargoBuildFlags = [ "--workspace" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version=branch"
      "--version-regex=^(?!latest-commit.*)(.*)$"
    ];
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
