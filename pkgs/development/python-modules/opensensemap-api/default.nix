{
  lib,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "opensensemap-api";
  version = "0.3.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "home-assistant-ecosystem";
    repo = "python-opensensemap-api";
    tag = version;
    hash = "sha256-iUSdjU41JOT7k044EI2XEvJiSo6V4mO6S51EcIughEM=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "opensensemap_api" ];

  meta = {
    description = "OpenSenseMap API Python client";
    longDescription = ''
      Python Client for interacting with the openSenseMap API. All
      available information from the sensor can be retrieved.
    '';
    homepage = "https://github.com/home-assistant-ecosystem/python-opensensemap-api";
    changelog = "https://github.com/home-assistant-ecosystem/python-opensensemap-api/releases/tag/${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
