{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest-cov-stub,
  pytest,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pglast";
  version = "7.11";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-d67Xi7eMDlbxaaQYM/b9x85jqjgwuMdx/CYxBaiDR0U=";
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

  meta = {
    description = "PostgreSQL Languages AST and statements prettifier";
    homepage = "https://github.com/lelit/pglast";
    changelog = "https://github.com/lelit/pglast/blob/v${version}/CHANGES.rst";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    mainProgram = "pgpp";
  };
}
