{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  testers,
  todoist-cli,
}:
buildNpmPackage rec {
  pname = "todoist-cli";
  version = "1.75.3";

  src = fetchFromGitHub {
    owner = "Doist";
    repo = "todoist-cli";
    rev = "v${version}";
    sha256 = "sha256-OqpwGMMEVpCLogSarf+RJBHXxvSf9EulwYO5hsuDXPY=";
  };

  npmDepsHash = "sha256-Wz7UxeZwC0boDBb9hGomELJ37mK+3aL8szpYDYDtjUg=";

  doCheck = true;

  __structuredAttrs = true;

  passthru.tests.version = testers.testVersion {
    package = todoist-cli;
  };

  meta = {
    description = "A command-line interface for Todoist";
    homepage = "https://github.com/Doist/todoist-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ joaosreis ];
    mainProgram = "td";
  };
}
