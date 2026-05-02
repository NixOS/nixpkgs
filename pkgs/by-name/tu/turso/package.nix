{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "turso";
  version = "0.6.0-pre.11";

  src = fetchFromGitHub {
    owner = "tursodatabase";
    repo = "turso";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yC7uwdkU2WF8ekZSGs+RufCE/5kjGbHL7c7yNtwT56s=";
  };

  cargoHash = "sha256-g8WRlUv+QOq6jxQq/d9SMQvnN1vR0jLq8yTaWVU0BYE=";

  cargoBuildFlags = [
    "-p"
    "turso_cli"
  ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Interactive SQL shell for Turso";
    homepage = "https://github.com/tursodatabase/turso";
    changelog = "https://github.com/tursodatabase/turso/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nartsiss ];
    mainProgram = "tursodb";
  };
})
