{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "turso";
  version = "0.7.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tursodatabase";
    repo = "turso";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eRB8IM7cda7UaYfX5dIubIK4K0M6ydrTxyLAUPB9/WM=";
  };

  cargoHash = "sha256-94lXY24XnURv6ebr4I/O8Rzk/iqflo7fib18S7XPhdU=";

  cargoBuildFlags = [
    "--bin"
    "tursodb"
  ];

  cargoTestFlags = finalAttrs.cargoBuildFlags;

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
