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
  version = "1.28.1";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-a3EInGYsVt5vmAovT+FSWtNIRY/5ckWvDOZi1EV0ZsU=";
  };

  cargoHash = "sha256-8Y7DZCQakP6gsXXA294gz8SlZROoKATJfxLY8ITlIf8=";

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
