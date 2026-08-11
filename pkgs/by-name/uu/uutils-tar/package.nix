{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-tar";
  version = "0-unstable-2026-07-22";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "tar";
    rev = "982bff5adb70954d24d0c2ce5909de655da83c72";
    hash = "sha256-WLxM9syVdwtejGnu0b7uQKewch2E+utBtHKqveZXvLw=";
  };

  cargoHash = "sha256-wDBY2yWgQpH4Ps8h3fTQawYVvVx4d8dMSAVj0WSgbzg=";

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
