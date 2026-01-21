{
  lib,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyemby";
  version = "1.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mezz64";
    repo = "pyemby";
    tag = version;
    hash = "sha256-+A/SNMCUqo9TwWsQXwOKJCqmYhbilIdHYazLNQY+NkU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    async-timeout
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyemby" ];

  meta = {
    description = "Python library to interface with the Emby API";
    homepage = "https://github.com/mezz64/pyemby";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
