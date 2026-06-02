{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  babel,
  gitpython,
  mkdocs,
  pytz,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mkdocs-git-revision-date-localized-plugin";
  version = "1.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "timvink";
    repo = "mkdocs-git-revision-date-localized-plugin";
    tag = "v${version}";
    hash = "sha256-h27LzLgOsobRuvieQsVwZSQkagJR3Vy5kUw/HqJ9BHE=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    babel
    gitpython
    mkdocs
    pytz
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [ "tests/test_builds.py" ];

  pythonImportsCheck = [ "mkdocs_git_revision_date_localized_plugin" ];

  meta = {
    description = "MkDocs plugin that enables displaying the date of the last git modification of a page";
    homepage = "https://github.com/timvink/mkdocs-git-revision-date-localized-plugin";
    changelog = "https://github.com/timvink/mkdocs-git-revision-date-localized-plugin/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ totoroot ];
  };
}
