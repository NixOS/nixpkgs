{
  lib,
  bitlist,
  buildPythonPackage,
  fetchPypi,
  fountains,
  parts,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "fe25519";
  version = "1.5.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-la+17tPHjceMTe7Wk8DGVaSptk8XJa+l7GTeqLIFDvs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    bitlist
    fountains
    parts
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "fe25519" ];

  meta = with lib; {
    description = "Python field operations for Curve25519's prime";
    homepage = "https://github.com/BjoernMHaase/fe25519";
    license = with licenses; [ cc0 ];
    maintainers = with maintainers; [ fab ];
  };
}
