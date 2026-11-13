{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  pkg-config,
  zstd,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "turso";
  version = "0.8.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tursodatabase";
    repo = "turso";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wUbRmGo4eQtwKXm/tGyxyqJOeqwG1EWBjuCyfp7mVzQ=";
  };

  cargoHash = "sha256-7AoiZAX9wKlPUVhb5HH4b9u8xT0EZ2OksHNMZQVcTjs=";

  cargoBuildFlags = [
    "--bin"
    "tursodb"
  ];

  cargoTestFlags = finalAttrs.cargoBuildFlags;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    zstd
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { extraArgs = [ "--version-regex=^v([0-9.]+)$" ]; };

  meta = {
    description = "Interactive SQL shell for Turso";
    homepage = "https://github.com/tursodatabase/turso";
    changelog = "https://github.com/tursodatabase/turso/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nartsiss ];
    mainProgram = "tursodb";
  };
})
