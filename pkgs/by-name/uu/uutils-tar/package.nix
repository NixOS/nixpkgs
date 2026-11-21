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
  version = "0-unstable-2026-11-11";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "tar";
    rev = "9896d5df6fdf44e9be0ba51d63c71099e4e346ca";
    hash = "sha256-TapHBA+3sThfmA3SUD9LeEqUSLTo+SCI87s8HIoJkkw=";
  };

  cargoHash = "sha256-UgRcmHzLlFetL3fUp2TpKMD9VN/qMBUTywh658CBadQ=";

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
