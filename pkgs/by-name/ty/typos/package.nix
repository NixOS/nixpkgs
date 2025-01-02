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
  version = "1.28.4";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-rE1JK6bG8yNItzsXEggTqKFuIwlFLDnIlNBUCjb9XOg=";
  };

  cargoHash = "sha256-DQWOAlVKtB0l0qaHCgsrUl239PcKDnic3kdKoSgOjik=";

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
