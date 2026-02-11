{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-tar";
  version = "0-unstable-2026-02-04";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "tar";
    rev = "7c563ac2bad0527558dabd82b57a2c72a458a812";
    hash = "sha256-XYSCqXUxtE07o/elHKUnP6hDzWYP1XIfifU31mQ/z2o=";
  };

  cargoHash = "sha256-4PFGlgkosF3qU9GnyR34tlarYxiG+ek4VERK1ZI/2pg=";

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
