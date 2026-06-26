{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-tar";
  version = "0-unstable-2026-06-23";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "tar";
    rev = "ad4e2e31cc9547868dc9137c882db0ea45f89d32";
    hash = "sha256-p4dkjLwV8SUDGx/atIajYW19+eDgC0AGlHzFOoVHFlA=";
  };

  cargoHash = "sha256-aY0dJaYmpQkeFUcYJDnknwEdopa0Sf1hs4Yux+bSBDo=";

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
