{
  lib,
  buildPythonPackage,
  fetchPypi,
  makefun,
  decopatch,
  packaging,
  pytest,
  setuptools_80,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pytest-cases";
  version = "3.10.1";
  pyproject = true;

  src = fetchPypi {
    pname = "pytest_cases";
    inherit version;
    hash = "sha256-RR+ePs1dLYGkNiwQxEESb1s9GuOn769Z9gsfuTDfLWk=";
  };

  patches = [
    # https://github.com/smarie/python-pytest-cases/issues/385
    # https://github.com/smarie/python-pytest-cases/pull/386
    ./pytest-9.1-compat.patch
  ];

  build-system = [
    setuptools_80
    setuptools-scm
  ];

  dependencies = [
    decopatch
    makefun
    packaging
    pytest
  ];

  # Tests have dependencies (pytest-harvest, pytest-steps) which
  # are not available in Nixpkgs. Most of the packages (decopatch,
  # makefun, pytest-*) have circular dependencies.
  doCheck = false;

  pythonImportsCheck = [ "pytest_cases" ];

  meta = {
    description = "Separate test code from test cases in pytest";
    homepage = "https://github.com/smarie/python-pytest-cases";
    changelog = "https://github.com/smarie/python-pytest-cases/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
