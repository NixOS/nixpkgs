{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest-cov-stub,
  pytest,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pglast";
  version = "7.7";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Xfv8H6OYGWQ6O5FaE2aOQ7vWwLAUqt9dC0MJ6GC6y7A=";
  };

  build-system = [ setuptools ];

  dependencies = [ setuptools ];

  nativeCheckInputs = [
    pytest
    pytest-cov-stub
  ];

  # pytestCheckHook doesn't work
  # ImportError: cannot import name 'parse_sql' from 'pglast'
  checkPhase = ''
    pytest
  '';

  pythonImportsCheck = [
    "pglast"
    "pglast.parser"
  ];

  meta = with lib; {
    description = "PostgreSQL Languages AST and statements prettifier";
    homepage = "https://github.com/lelit/pglast";
    changelog = "https://github.com/lelit/pglast/blob/v${version}/CHANGES.rst";
    license = licenses.gpl3Plus;
    maintainers = [ ];
    mainProgram = "pgpp";
  };
}
