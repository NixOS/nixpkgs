{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  urllib3,
}:

buildPythonPackage rec {
  pname = "python-opendata-transport";
  version = "0.5.0";
  pyproject = true;

  src = fetchPypi {
    pname = "python_opendata_transport";
    inherit version;
    hash = "sha256-CtYsks7Q33ww0Mr9ehhq7+fJhCsj4gxKytiCZ6G4Aqc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    urllib3
  ];

  # No tests are present
  doCheck = false;

  pythonImportsCheck = [ "opendata_transport" ];

  meta = {
    description = "Python client for interacting with transport.opendata.ch";
    homepage = "https://github.com/home-assistant-ecosystem/python-opendata-transport";
    changelog = "https://github.com/home-assistant-ecosystem/python-opendata-transport/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
