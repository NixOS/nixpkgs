{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-tar";
  version = "0-unstable-2026-08-28";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "tar";
    rev = "6999aa1c21783767897b96a1bba5dd913c733351";
    hash = "sha256-9w7eYXf/UiM3rvkpIm2GIrRxL94v3I+KvnQdfhnbDPk=";
  };

  cargoHash = "sha256-mUHlPibVWPR9SOUZ6yHFD5nZoEiMt1uNfUxSqMpSuCI=";

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
