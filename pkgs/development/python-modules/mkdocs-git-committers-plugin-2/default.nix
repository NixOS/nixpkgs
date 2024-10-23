{
  # Evaluation
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # Build
  setuptools,

  # Dependencies
  gitpython,
  mkdocs,
  requests,
}:

buildPythonPackage rec {
  pname = "mkdocs-git-committers-plugin-2";
  version = "2.4.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ojacques";
    repo = "mkdocs-git-committers-plugin-2";
    rev = "refs/tags/${version}";
    hash = "sha256-hKt0K5gOkdUDwTlyMTwodl4gD1RD+s+CM+zEpngSnlc=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    gitpython
    mkdocs
    requests
  ];

  # Upstream has no tests
  doCheck = false;
  pythonImportsCheck = [ "mkdocs_git_committers_plugin_2" ];

  meta = {
    description = "MkDocs plugin for displaying a list of contributors on each page";
    homepage = "https://github.com/ojacques/mkdocs-git-committers-plugin-2";
    changelog = "https://github.com/ojacques/mkdocs-git-committers-plugin-2/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mahtaran ];
  };
}
