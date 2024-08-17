{
  lib,
  fetchPypi,
  buildPythonPackage,
  pythonOlder,

  # build-system
  setuptools,

  # dependencies
  aiohttp,
  attrs,
  python-socks,
}:

buildPythonPackage rec {
  pname = "aiohttp-socks";
  version = "0.9.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit version;
    pname = "aiohttp_socks";
    hash = "sha256-IhWaGvAmsinP5eoAfgZbs/5WOFqVGoJiOm9FiKZ1gAM=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    aiohttp
    attrs
    python-socks
  ];

  # Checks needs internet access
  doCheck = false;

  pythonImportsCheck = [ "aiohttp_socks" ];

  meta = {
    description = "SOCKS proxy connector for aiohttp";
    license = lib.licenses.asl20;
    homepage = "https://github.com/romis2012/aiohttp-socks";
  };
}
