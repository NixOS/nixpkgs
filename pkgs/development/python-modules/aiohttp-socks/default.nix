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
  version = "0.10.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit version;
    pname = "aiohttp_socks";
    hash = "sha256-SfLh+AUfKIVxm+sbd+MStaJ8Pktg8LBFo4jxlNmV4Gg=";
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
