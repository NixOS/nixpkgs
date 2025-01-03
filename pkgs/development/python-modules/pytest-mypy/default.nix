{
  lib,
  attrs,
  buildPythonPackage,
  fetchPypi,
  filelock,
  pytest,
  mypy,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pytest-mypy";
  version = "0.10.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+EWPZCMj8Toso+LmFQn3dnlmtSe02K3M1QMsPntP09s=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  buildInputs = [ pytest ];

  propagatedBuildInputs = [
    attrs
    mypy
    filelock
  ];

  # does not contain tests
  doCheck = false;
  pythonImportsCheck = [ "pytest_mypy" ];

  meta = {
    description = "Mypy static type checker plugin for Pytest";
    homepage = "https://github.com/dbader/pytest-mypy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
