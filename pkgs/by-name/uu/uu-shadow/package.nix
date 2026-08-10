{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  libxcrypt,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uu-shadow";
  version = "0.2.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "shadow";
    tag = "v${finalAttrs.version}";
    hash = "sha256-73Nd3BP0CtEgCywsT9hseOX5lmQQaXO/XQDs/wUQ1KY=";
  };

  cargoHash = "sha256-tqyWrbbz5CkkBN9bkUMOD1w6Y7RKn8MmN/7lPb+O4mA=";

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
