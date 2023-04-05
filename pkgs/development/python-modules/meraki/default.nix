{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
, requests
}:

buildPythonPackage rec {
  pname = "meraki";
  version = "1.30.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-s26xGwWSWB+qpOTUe8IYo53ywYOaaUWjDznFqpmRlak=";
  };

  propagatedBuildInputs = [
    aiohttp
    requests
  ];

  pythonImportsCheck = [
    "meraki"
  ];

  meta = with lib; {
    description = "Provides all current Meraki dashboard API calls to interface with the Cisco Meraki cloud-managed platform";
    homepage = "https://github.com/meraki/dashboard-api-python";
    license = licenses.mit;
    maintainers = with maintainers; [ dylanmtaylor ];
  };
}
