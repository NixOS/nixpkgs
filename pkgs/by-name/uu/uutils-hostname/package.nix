{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-hostname";
  version = "0-unstable-2026-01-28";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "hostname";
    rev = "99bba3d33b03da1ff7d961d542ad5804d007b76c";
    hash = "sha256-f5LTvSsBsFbK9+MMiJQRvY2ze1t4qE2mEUsV0+2oO9A=";
  };

  cargoHash = "sha256-nbpyflP4J6V6aEeCp5I+FP2NNmXDS4JhbGWUBbOyJEc=";

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Rust reimplementation of the hostname project";
    homepage = "https://github.com/uutils/hostname";
    license = lib.licenses.mit;
    mainProgram = "hostname";
    maintainers = with lib.maintainers; [ kyehn ];
    platforms = lib.platforms.unix;
  };
})
