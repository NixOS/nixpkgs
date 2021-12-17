{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "opensensemap-api";
  version = "0.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-KSukSPpSbfbEEqTq4zqqo8OT7ptdPrGy2QyQYjErQWI=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  # no tests are present
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
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
