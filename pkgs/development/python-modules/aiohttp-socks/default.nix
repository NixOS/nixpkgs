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
  version = "0.11.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "aiohttp_socks";
    hash = "sha256-Cv5RY4Unx5B35L1uVwUsh8SCQjPW4guwYcU3ZkIbEPA=";
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
