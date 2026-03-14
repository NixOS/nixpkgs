{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "prana-api-client";
  version = "0.10.0";
  pyproject = true;

  src = fetchPypi {
    pname = "prana_api_client";
    inherit (finalAttrs) version;
    hash = "sha256-w2mSZpI18069etdZ+dLXBrDMzgMJwPSeE2GAFzW2aJA=";
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
