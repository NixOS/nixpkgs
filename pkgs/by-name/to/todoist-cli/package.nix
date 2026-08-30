{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  testers,
  todoist-cli,
}:
buildNpmPackage rec {
  pname = "todoist-cli";
  version = "3.3.2";

  src = fetchFromGitHub {
    owner = "Doist";
    repo = "todoist-cli";
    rev = "v${version}";
    sha256 = "sha256-vkLqq76NmPrNZ411K98fc7tXB4O1KyuZRhes6wCgoZM=";
  };

  npmDepsHash = "sha256-/aP5URXvyTNzRuEIPgcIOh222jfvoAdMmLWGzVplqhQ=";

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
