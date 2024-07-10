{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
  certifi,
  pythonOlder,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "crownstone-cloud";
  version = "1.4.11";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "crownstone_cloud";
    inherit version;
    hash = "sha256-s84pK52uMupxQfdMldV14V3nj+yVku1Vw13CRX4o08U=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    certifi
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "crownstone_cloud" ];

  meta = with lib; {
    description = "Python module for communicating with Crownstone Cloud and devices";
    homepage = "https://github.com/Crownstone-Community/crownstone-lib-python-cloud";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
