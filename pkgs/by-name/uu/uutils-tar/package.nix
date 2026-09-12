{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-tar";
  version = "0-unstable-2026-09-05";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "tar";
    rev = "7e97cd72ccf93e7c0ebb668af4586ddfcc33a238";
    hash = "sha256-0XkOcSAhcmTfqjzWT6CGdbTYj6w3l1ZOdib7z/HIK70=";
  };

  cargoHash = "sha256-4K93gSgTl917UmJm1okDhiiN4sB5EqTM3Frr77ZTIXY=";

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
