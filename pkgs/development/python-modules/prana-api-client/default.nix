{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "prana-api-client";
  version = "0.12.0";
  pyproject = true;

  src = fetchPypi {
    pname = "prana_api_client";
    inherit (finalAttrs) version;
    hash = "sha256-woERY0H9s8P6z375axzPz2k5VWb0xRJtWcAuWtLFtJU=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "prana_local_api_client" ];

  meta = {
    description = "Async API client for Prana heat recovery ventilator";
    homepage = "https://pypi.org/project/prana-api-client/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
