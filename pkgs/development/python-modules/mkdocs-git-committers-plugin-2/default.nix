{
  # Evaluation
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

  # Dependencies
  gitpython,
  mkdocs,
  requests,
}:

buildPythonPackage rec {
  pname = "mkdocs-git-committers-plugin-2";
  version = "2.3.0";
  format = "setuptools";

  disabled = !pythonAtLeast "3.8";

  src = fetchFromGitHub {
    owner = "ojacques";
    repo = "mkdocs-git-committers-plugin-2";
    rev = "refs/tags/${version}";
    hash = "sha256-+Ua2oX8PrfTROAhXNjcKdjIajVfvP3D3ToddFfj5N6A=";
  };

  propagatedBuildInputs = [
    gitpython
    mkdocs
    requests
  ];

  pythonImportsCheck = [ "mkdocs_git_committers_plugin_2" ];

  meta = {
    description = "MkDocs plugin for displaying a list of contributors on each page";
    homepage = "https://github.com/ojacques/mkdocs-git-committers-plugin-2";
    changelog = "https://github.com/ojacques/mkdocs-git-committers-plugin-2/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mahtaran ];
  };
}
