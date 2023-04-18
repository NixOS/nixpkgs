{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
, requests
}:

buildPythonPackage rec {
  pname = "meraki";
  version = "1.32.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3iZ9/d78nAnK2+Kv0+0tuvZcfSV6ZF6QRF3xYL3NqV4=";
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
