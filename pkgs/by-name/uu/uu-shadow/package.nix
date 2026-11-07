{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  libxcrypt,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uu-shadow";
  version = "0.6.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "shadow";
    tag = finalAttrs.version;
    hash = "sha256-yvLvm4vBnbHgBHSy/mX0YMCt+5u33mCbSJ9EtYMLIcU=";
  };

  cargoHash = "sha256-mnNpLf27Vqhjb8/oebjRRpcy2BJvMWPC3mcbjXJlMRA=";

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
