{
  lib,
  buildPythonPackage,
  fetchPypi,
  parts,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "bitlist";
  version = "2.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mbXSvIUYsnZy/pmZLFXa1bqrwK+JZ2eySuDRCVAs1zk=";
  };

  pythonRelaxDeps = [ "parts" ];

  build-system = [ setuptools ];

  dependencies = [ parts ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "bitlist" ];

  meta = with lib; {
    description = "Python library for working with little-endian list representation of bit strings";
    homepage = "https://github.com/lapets/bitlist";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
