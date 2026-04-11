{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-login";
  version = "0-unstable-2026-04-07";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "login";
    rev = "20df30470f98dc50af80c23f53cd6cacc64e85c3";
    hash = "sha256-YQsnKpJRG3rEllKb4KtPi+lUeGoywh/UGsMfvRBdu4M=";
  };

  cargoHash = "sha256-dKpgyGcZEEx94iQH7NnO/X1+KLE/Bcdl1FFT7ijS1WE=";

  cargoBuildFlags = [ "--workspace" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Rust reimplemtation of the login project";
    homepage = "https://github.com/uutils/login";
    license = lib.licenses.mit;
    mainProgram = "shadow";
    maintainers = with lib.maintainers; [ kyehn ];
    platforms = lib.platforms.unix;
  };
})
