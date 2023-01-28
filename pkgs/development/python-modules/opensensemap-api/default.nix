{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "opensensemap-api";
  version = "0.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lz2G7vXUadhTFgfHpIq9kHfojf+iytjitFZZ7rgqeO8=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "opensensemap_api"
  ];

  meta = with lib; {
    description = "OpenSenseMap API Python client";
    longDescription = ''
      Python Client for interacting with the openSenseMap API. All
      available information from the sensor can be retrieved.
    '';
    homepage = "https://github.com/home-assistant-ecosystem/python-opensensemap-api";
    changelog = "https://github.com/home-assistant-ecosystem/python-opensensemap-api/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
