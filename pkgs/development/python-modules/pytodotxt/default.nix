{
  lib,
  buildPythonPackage,
  fetchFromGitea,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytodotxt";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "vonshednob";
    repo = "pytodotxt";
    tag = "v${version}";
    hash = "sha256-f85PgMIMoR/HPPqTdwjymF1mE19pWaPMtSJNQ8UfvP0=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    unittestCheckHook
  ];

  unittestFlagsArray = [
    "-s"
    "tests"
  ];

  pythonImportsCheck = [ "pytodotxt" ];

  meta = {
    description = "Python library to access todo.txt-like task lists";
    homepage = "https://vonshednob.cc/pytodotxt/";
    changelog = "https://codeberg.org/vonshednob/pytodotxt/src/branch/main/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.amadejkastelic ];
  };
}
