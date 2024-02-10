{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, setuptools-scm
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-datadir";
  version = "1.5.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "gabrielcnr";
    repo = "pytest-datadir";
    rev = "refs/tags/v${version}";
    hash = "sha256-sRLqL+8Jf5Kz+qscuG3hClUuPA+33PQa+ob1ht/7CJE=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_datadir" ];

  meta = with lib; {
    description = "Pytest plugin for manipulating test data directories and files";
    homepage = "https://github.com/gabrielcnr/pytest-datadir";
    changelog = "https://github.com/gabrielcnr/pytest-datadir/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ kira-bruneau ];
  };
}
