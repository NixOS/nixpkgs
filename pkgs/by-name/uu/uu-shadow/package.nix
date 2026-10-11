{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  libxcrypt,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uu-shadow";
  version = "0.5.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "shadow";
    tag = finalAttrs.version;
    hash = "sha256-ZobCLU71pEnq92Dm8debfUryJrTNyBAN2blVaRmWQWQ=";
  };

  cargoHash = "sha256-eZ/R2pDbNWdiEMcUS+bZCFdLK1Dr68Xmly+FKzyCzzY=";

  buildInputs = [ libxcrypt ];

  cargoBuildFlags = [ "--workspace" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Memory-safe Rust reimplementation of Linux shadow-utils";
    homepage = "https://github.com/uutils/shadow";
    license = lib.licenses.mit;
    mainProgram = "shadow-rs";
    maintainers = with lib.maintainers; [ kyehn ];
    platforms = lib.platforms.linux;
  };
})
