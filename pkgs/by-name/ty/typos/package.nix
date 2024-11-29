{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
  nix-update-script,
  typos,
}:

rustPlatform.buildRustPackage rec {
  pname = "typos";
  version = "1.27.3";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-4vIRhhBvK2R0nAdG4zDTJ+6F3WOI9sAB/ongBMnzsWk=";
  };

  cargoHash = "sha256-cn1jy8kQ6R+JU6w/sqcNP+uzSKKg3V4H97qnJAIESd0=";

  passthru = {
    tests.version = testers.testVersion { package = typos; };

    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Source code spell checker";
    mainProgram = "typos";
    homepage = "https://github.com/crate-ci/typos";
    changelog = "https://github.com/crate-ci/typos/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [
      figsoda
      mgttlinger
    ];
  };
}
