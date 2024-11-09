{
  lib,
  aiohttp,
  attrs,
  buildPythonPackage,
  fetchPypi,
  python-socks,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aiohttp-socks";
  version = "0.9.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit version;
    pname = "aiohttp_socks";
    hash = "sha256-IhWaGvAmsinP5eoAfgZbs/5WOFqVGoJiOm9FiKZ1gAM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    attrs
    python-socks
  ] ++ python-socks.optional-dependencies.asyncio;

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
