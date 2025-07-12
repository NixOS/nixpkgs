{
  lib,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyemby";
  version = "1.10";
  pyproject = true;

  disabled = pythonOlder "3.8";

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

  meta = with lib; {
    description = "Python library to interface with the Emby API";
    homepage = "https://github.com/mezz64/pyemby";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
