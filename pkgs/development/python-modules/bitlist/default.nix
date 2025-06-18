{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  parts,
  pytestCheckHook,
  pytest-cov-stub,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "bitlist";
  version = "1.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+/rBno+OH7yEiN4K9VC6BCEPuOv8nNp0hU+fWegjqPw=";
  };

  build-system = [
    setuptools
    wheel
  ];

  pythonRelaxDeps = [ "parts" ];

  dependencies = [ parts ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "bitlist" ];

  meta = with lib; {
    description = "Python library for working with little-endian list representation of bit strings";
    homepage = "https://github.com/lapets/bitlist";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
