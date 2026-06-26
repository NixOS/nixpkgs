{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-tar";
  version = "0-unstable-2026-06-15";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "tar";
    rev = "4c1c362e5766760b7ffc120f0ccf25a5344122c5";
    hash = "sha256-oLa9KGqcSay3u6Jt3BMNz/evwS3g7u627qOhlqR+1Eg=";
  };

  cargoHash = "sha256-xZqRhBq5zhCvJ6/qAXYNsylFpph6EiPobH0SuWHCtes=";

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
