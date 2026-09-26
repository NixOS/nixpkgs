{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "asyncudp";
  version = "0.11.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yKtkWfTcjrxC9AHTvXLCpsaAjRDkIjHzngxDOsZGq/k=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "asyncudp" ];

  meta = {
    description = "Asyncio high level UDP sockets";
    homepage = "https://github.com/eerimoq/asyncudp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kanagawamarcos ];
  };
}
