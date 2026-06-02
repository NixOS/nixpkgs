{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-tar";
  version = "0-unstable-2026-05-13";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "tar";
    rev = "840b16bd8fd53a2fe4e8780d710014c2908b9870";
    hash = "sha256-ZCTg7LEJdG6AzbR22l5MsNo17IO+eWO6dgFINx5xUeA=";
  };

  cargoHash = "sha256-tv+Rw7fS2llSJBVhfsGSGcovcdU+8ZYNa89K+LYdcFg=";

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
