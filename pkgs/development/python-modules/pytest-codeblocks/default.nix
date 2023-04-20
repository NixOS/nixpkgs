{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pytest
, pytest-cov
, setuptools
}:

buildPythonPackage rec {
  pname = "pytest-codeblocks";
  version = "0.16.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "nschloe";
    repo = "pytest-codeblocks";
    rev = "v${version}";
    hash = "sha256-mFZ2F31d2irjrXgYS9WufBAXFzdmn9YOXM9zDP5tndY=";
  };

  propagatedBuildInputs = [
    pytest
    setuptools
  ];

  pythonImportsCheck = [ "pytest_codeblocks" ];

  checkInputs = [
    pytest-cov
  ];

  pytestFlagsArray = [
    "-p"
    "pytester"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    "tests/test_shell.py" # Requires shell usage
  ];

  meta = {
    homepage = "https://github.com/nschloe/pytest-codeblocks";
    changelog = "https://github.com/nschloe/pytest-codeblocks/releases/tag/v${version}";
    description = "Test code blocks in your READMEs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ swflint ];
  };
}
