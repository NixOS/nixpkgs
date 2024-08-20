{
  lib,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "pyemby";
  version = "1.9";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mezz64";
    repo = pname;
    rev = version;
    hash = "sha256-4mOQLfPbRzZzpNLvekJHVKiqdGGKPhW6BpKkyRfk2Pc=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyemby" ];

  meta = with lib; {
    description = "Python library to interface with the Emby API";
    homepage = "https://github.com/mezz64/pyemby";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
