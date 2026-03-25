{
  lib,
  aiohttp,
  buildPythonPackage,
  certifi,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "crownstone-sse";
  version = "2.0.5";
  pyproject = true;

  src = fetchPypi {
    pname = "crownstone_sse";
    inherit version;
    hash = "sha256-RUqo68UAVGV+JmauKsGlp7dG8FzixHBDnr3eho/IQdY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    certifi
  ];

  # Tests are only providing coverage
  doCheck = false;

  pythonImportsCheck = [ "crownstone_sse" ];

  meta = {
    description = "Python module for listening to Crownstone SSE events";
    homepage = "https://github.com/Crownstone-Community/crownstone-lib-python-sse";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
