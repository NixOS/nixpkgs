{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "typos";
  version = "1.40.1";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = "typos";
    tag = "v${version}";
    hash = "sha256-L5rWQ7jYrayNXowk/h8ajJb9nCzhnrrVVskhay+RaGA=";
  };

  cargoHash = "sha256-hO18bPAzJoXqXMjuJndAzRWg5IeRLIeRzKyajukg7L0=";

  passthru.updateScript = nix-update-script { };

  preCheck = ''
    export LC_ALL=C.UTF-8
  '';

  postCheck = ''
    unset LC_ALL
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Source code spell checker";
    mainProgram = "typos";
    homepage = "https://github.com/crate-ci/typos";
    changelog = "https://github.com/crate-ci/typos/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      mgttlinger
    ];
  };
}
