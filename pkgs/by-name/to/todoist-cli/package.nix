{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  testers,
  todoist-cli,
}:
buildNpmPackage rec {
  pname = "todoist-cli";
  version = "3.0.6";

  src = fetchFromGitHub {
    owner = "Doist";
    repo = "todoist-cli";
    rev = "v${version}";
    sha256 = "sha256-gt9/RSmVvgvWjBIKElt1A/Z7vbr9ACxgAvgtcnQ8V6A=";
  };

  npmDepsHash = "sha256-BjN7fvUbycqgFb3LVvOmQFWXlj7hcBC98k8tGWxGvE8=";

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
