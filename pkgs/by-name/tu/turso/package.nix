{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "turso";
  version = "0.4.4-pre.3";

  src = fetchFromGitHub {
    owner = "tursodatabase";
    repo = "turso";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VT5ErH0h3eotOlEeyoARy+KD9iiDOVhfXSy8sVT8uDk=";
  };

  cargoHash = "sha256-82PzmCikp9Hkn8px/Wml1SbEJrQUeGJ5sHYy50nLFQg=";

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
