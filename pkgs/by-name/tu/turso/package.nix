{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "turso";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "tursodatabase";
    repo = "turso";
    tag = "v${finalAttrs.version}";
    hash = "sha256-exlwgw7z4XSAdYrsp8yvUjUgKA+hOl9ocMsf1D4oRho=";
  };

  cargoHash = "sha256-UeyW+fUQWE7VUMW/MRcKReHG7PpoDmQ16VMx4p+NPQw=";

  cargoBuildFlags = [
    "-p"
    "turso_cli"
  ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { extraArgs = [ "--version-regex=^v([0-9.]+)$" ]; };

  meta = {
    description = "Interactive SQL shell for Turso";
    homepage = "https://github.com/tursodatabase/turso";
    changelog = "https://github.com/tursodatabase/turso/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nartsiss ];
    mainProgram = "tursodb";
  };
})
