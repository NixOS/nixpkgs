{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  jinja2,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "jinja2-git";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wemake-services";
    repo = "jinja2-git";
    tag = version;
    hash = "sha256-ZcKRLHcZ/rpiUyYK4ifDJaZriN+YyRF1RKCjIKum98U=";
  };

  build-system = [ poetry-core ];

  dependencies = [ jinja2 ];

  # the tests need to be run on the git repository
  doCheck = false;

  pythonImportsCheck = [ "jinja2_git" ];

  meta = {
    homepage = "https://github.com/wemake-services/jinja2-git";
    description = "Jinja2 extension to handle git-specific things";
    changelog = "https://github.com/wemake-services/jinja2-git/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cpcloud ];
  };
}
