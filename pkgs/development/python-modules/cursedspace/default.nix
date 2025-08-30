{
  lib,
  buildPythonPackage,
  fetchFromGitea,
  docutils,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "cursedspace";
  version = "1.5.2";
  pyproject = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "vonshednob";
    repo = "cursedspace";
    tag = "v${version}";
    hash = "sha256-aqjVdjijfrmjeNsjHyYuWIbX9v65bGbQMcK0NahYKpc=";
  };

  build-system = [
    docutils
    setuptools
  ];

  nativeCheckInputs = [
    unittestCheckHook
  ];

  unittestFlagsArray = [
    "-s"
    "tests"
  ];

  pythonImportsCheck = [ "cursedspace" ];

  meta = {
    description = "Python library/framework for TUI application on the basis of the curses package";
    homepage = "https://vonshednob.cc/cursedspace/";
    changelog = "https://codeberg.org/vonshednob/cursedspace/src/branch/main/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.amadejkastelic ];
  };
}
