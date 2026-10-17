{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,

  pydantic,
  aiohttp,
  async-lru,
  tenacity,
  cachetools,
  requests,

  httpx,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "buildgrid-metering-client";
  version = "0.0.4";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-mA1nBIYZ8i/zaJzEe3ZVRcdxgy84HvmIczA0Tpsl06c=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pydantic
    aiohttp
    async-lru
    tenacity
    cachetools
    requests
  ];

  nativeCheckInputs = [
    httpx
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "buildgrid_metering" ];

  meta = {
    description = "Client library of the BuildGrid metering service";
    homepage = "https://gitlab.com/BuildGrid/buildgrid-metering-client";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ shymega ];
  };
})
