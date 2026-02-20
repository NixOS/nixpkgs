{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-tar";
  version = "0-unstable-2026-02-11";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "tar";
    rev = "9743b70ac8d22454d23d1a0ab05a28581adac5d8";
    hash = "sha256-hCT4YbqFmWGEEyfypyzy9yD18htRklf/aa3uKYnbs3M=";
  };

  cargoHash = "sha256-GGh9TAGopJVjX+546unIto3FTtgOg67MFfiJSPjgaE8=";

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
