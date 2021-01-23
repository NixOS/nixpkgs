{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
, async-timeout
, urllib3
}:

buildPythonPackage rec {
  pname = "python-opendata-transport";
  version = "0.2.1";

  src = fetchPypi {
    pname = "python_opendata_transport";
    inherit version;
    sha256 = "0pxs9zqk00vn1s74cx1416mqmixrr74wb0jb0j6b1c3xpvzlfbks";
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
