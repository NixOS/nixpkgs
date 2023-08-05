{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
, requests
}:

buildPythonPackage rec {
  pname = "meraki";
  version = "1.34.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rAFoIKHrhHRqcXmvbzlFKFIaHxVLp6CJUhNASwHhpPk=";
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
    changelog = "https://github.com/meraki/dashboard-api-python/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dylanmtaylor ];
  };
}
