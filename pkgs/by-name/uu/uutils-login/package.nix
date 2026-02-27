{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-login";
  version = "0-unstable-2026-02-17";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "login";
    rev = "71120650e42e1cfcbe0cb0c09d3e6c6bacdf49db";
    hash = "sha256-5SYFlltBoSMmX0IsdNRs6jRV5J3xNFYupH+X3TgNTUA=";
  };

  cargoHash = "sha256-iCS3n7nd5qVjTcMoTubQFl15ZY2cf0w91OBqtckNb44=";

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
