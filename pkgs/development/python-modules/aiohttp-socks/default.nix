{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
  python-socks,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aiohttp-socks";
  version = "0.10.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit version;
    pname = "aiohttp_socks";
    hash = "sha256-lC18huLleUGPx6c0YQ3ZfarwBwfHRi9sz2ebIyV2eTA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    python-socks
  ]
  ++ python-socks.optional-dependencies.asyncio;

  # Checks needs internet access
  doCheck = false;

  pythonImportsCheck = [ "aiohttp_socks" ];

  meta = {
    description = "SOCKS proxy connector for aiohttp";
    homepage = "https://github.com/romis2012/aiohttp-socks";
    changelog = "https://github.com/romis2012/aiohttp-socks/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
