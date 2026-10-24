{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-tar";
  version = "0-unstable-2026-10-18";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "tar";
    rev = "fe4564069f1fa481069ba0c9b5ea4c6ee87e7ee2";
    hash = "sha256-fObF9JrCnuVCCGZop+pP7ZtBePfyzAMkIfk6aghcNAg=";
  };

  cargoHash = "sha256-JVbRYc0vFeq/HQYTyTCH6f72Bf8+jCRyt3TmKkrr540=";

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
