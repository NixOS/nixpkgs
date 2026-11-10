{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  zstd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-tar";
  version = "0-unstable-2026-11-09";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "tar";
    rev = "02b9c9469069fa0c4f92acccb093a1c880532faf";
    hash = "sha256-fxb+NOuqKQ2/asrrrGnxXCDo9rl8tizZoqzjDE6ios8=";
  };

  cargoHash = "sha256-yUO4bPRMqyq7EQ6WGCEx/XPxVIpbxOdinS8RjGIjAdg=";

  cargoBuildFlags = [ "--workspace" ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ zstd ];

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
