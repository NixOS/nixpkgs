{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-tar";
  version = "0-unstable-2026-02-24";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "tar";
    rev = "364a54f557ffdbf501c742741b8f461ce2e4ce3d";
    hash = "sha256-7J2elCASjyLZFCT1mwJXRrk9qvvEy51WpLz4o4jw6nQ=";
  };

  cargoHash = "sha256-gWBn7ffsDdHkeCZGIMToK3wlj4Nf+2ibdNnC87M2E5Q=";

  cargoBuildFlags = [ "--workspace" ];

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
