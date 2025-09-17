{
  lib,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  pyjwt,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "millheater";
  version = "0.13.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pymill";
    tag = version; # https://github.com/Danielhiversen/pymill/issues/87
    hash = "sha256-fdKMX85uo5L/1ko5aXHzLcWbr24StzRV38jjEbeRRkw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    async-timeout
    pyjwt
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "mill" ];

  meta = with lib; {
    description = "Python library for Mill heater devices";
    homepage = "https://github.com/Danielhiversen/pymill";
    changelog = "https://github.com/Danielhiversen/pymill/releases/tag/${src.tag}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
