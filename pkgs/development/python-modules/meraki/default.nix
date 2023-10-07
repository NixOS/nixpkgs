{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "meraki";
  version = "1.37.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pq/+giQwxvMey5OS8OtKH8M5fKmDuweuod6+hviY7P8=";
  };

  propagatedBuildInputs = [
    aiohttp
    requests
  ];

  # All tests require an API key
  doCheck = false;

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
