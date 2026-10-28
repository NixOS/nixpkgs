{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
  python-socks,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aiohttp-socks";
  version = "0.12.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "aiohttp_socks";
    hash = "sha256-PK+fWkFkYREi1BK8EbL5EU/SnIXhuie7OAYNPCNr3I0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    python-socks
  ];

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
