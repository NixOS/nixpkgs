{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  testers,
  todoist-cli,
}:
buildNpmPackage rec {
  pname = "todoist-cli";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "Doist";
    repo = "todoist-cli";
    rev = "v${version}";
    sha256 = "sha256-5+FxpTQmxeoNF/lTjKvFxP1T7HYt7YaUflTvw0GcOac=";
  };

  npmDepsHash = "sha256-IVabpRYKMI6ST/TumG7pMwDoUMIJBlhjUm35Eo7mSlE=";

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
