{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
, async-timeout
, urllib3
}:

buildPythonPackage rec {
  pname = "python-opendata-transport";
  version = "0.2.2";

  src = fetchPypi {
    pname = "python_opendata_transport";
    inherit version;
    sha256 = "sha256-Z0VHkKYHpwbBwwFrMtA5JRy0m7f0566IjCmGizoKEoo=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    urllib3
  ];

  # no tests are present
  doCheck = false;

  pythonImportsCheck = [ "opendata_transport" ];

  meta = with lib; {
    description = "Python client for interacting with transport.opendata.ch";
    homepage = "https://github.com/home-assistant-ecosystem/python-opendata-transport";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
