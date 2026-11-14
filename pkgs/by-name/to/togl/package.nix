{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "togl";
  version = "0.5.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "smorin";
    repo = "toggle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JUs98p2FDWG4/0mh8LnX0UhPOKIuaBFBixqdnhjxGyM=";
  };

  cargoHash = "sha256-LO8dAvm9OegESxobknPBF5FrSCcQ29qNymPATWJ14z4=";

  # Virtual workspace: build and test only the CLI crate (binaries `toggle`, `togl`).
  cargoBuildFlags = [
    "-p"
    "togl-cli"
  ];
  cargoTestFlags = [
    "-p"
    "togl-cli"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI tool for toggling code comments across multiple languages";
    homepage = "https://github.com/smorin/toggle";
    changelog = "https://github.com/smorin/toggle/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ smorin ];
    mainProgram = "togl";
  };
})
