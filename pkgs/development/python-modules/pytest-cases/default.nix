{
  lib,
  buildPythonPackage,
  fetchPypi,
  makefun,
  decopatch,
  pythonOlder,
  pytest,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pytest-cases";
  version = "3.8.6";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "pytest_cases";
    inherit version;
    hash = "sha256-XCTgqwy2+OgCpGm3llkGozPTuruHRYbrxW9+LL4afEQ=";
  };

  build-system = [ setuptools-scm ];

  buildInputs = [ pytest ];

  dependencies = [
    decopatch
    makefun
  ];

  # Tests have dependencies (pytest-harvest, pytest-steps) which
  # are not available in Nixpkgs. Most of the packages (decopatch,
  # makefun, pytest-*) have circular dependencies.
  doCheck = false;

  pythonImportsCheck = [ "pytest_cases" ];

  meta = with lib; {
    description = "Separate test code from test cases in pytest";
    homepage = "https://github.com/smarie/python-pytest-cases";
    changelog = "https://github.com/smarie/python-pytest-cases/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
