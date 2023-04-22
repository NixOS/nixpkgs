{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
, urllib3
, pythonOlder
}:

buildPythonPackage rec {
  pname = "python-opendata-transport";
  version = "0.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "python_opendata_transport";
    inherit version;
    hash = "sha256-CpzMMp2C3UOiUna9EcUucD/PKv7AZlkaU8QJfWntoi8=";
  };

  propagatedBuildInputs = [
    aiohttp
    urllib3
  ];

  # no tests are present
  doCheck = false;

  pythonImportsCheck = [
    "opendata_transport"
  ];

  meta = with lib; {
    description = "Python client for interacting with transport.opendata.ch";
    homepage = "https://github.com/home-assistant-ecosystem/python-opendata-transport";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
