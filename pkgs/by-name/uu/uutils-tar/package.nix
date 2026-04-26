{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-tar";
  version = "0-unstable-2026-04-23";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "tar";
    rev = "f6b4dc4f2f8fba1f264889a3cb139a16e1d135b1";
    hash = "sha256-LnNbfBoCwPpyPVNeE4s3gxHzMVJJ8konB6+KsD6dU8M=";
  };

  cargoHash = "sha256-WVtJAH5JYwoiMekUSiG0uhHqlXPTFYCB0TNQOcMbGkE=";

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
