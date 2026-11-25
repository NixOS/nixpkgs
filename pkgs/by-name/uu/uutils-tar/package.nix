{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  zstd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-tar";
  version = "0-unstable-2026-11-25";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "tar";
    rev = "a8c65b2dad76ddb19fc014ab298dfd9836090378";
    hash = "sha256-r4aPbeKr4+Egqik/1QOrjOV1EJ78UR3XSZ0GjhcpKGo=";
  };

  cargoHash = "sha256-y70QUPexK8vnObbVBZZoaWeQkzASXeKrGKg4y9//KCw=";

  cargoBuildFlags = [ "--workspace" ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ zstd ];

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
