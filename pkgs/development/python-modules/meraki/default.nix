{ lib
<<<<<<< HEAD
, aiohttp
, buildPythonPackage
, fetchPypi
, pythonOlder
=======
, buildPythonPackage
, fetchPypi
, aiohttp
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, requests
}:

buildPythonPackage rec {
  pname = "meraki";
<<<<<<< HEAD
  version = "1.36.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VkXA5eEIEcyPlyI566rwtmIGauxD4ra0Q4ccH4ojc0U=";
=======
  version = "1.33.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uzrnKYCythDa+DK1X87zcL9O4cmjRDqxR2hXoN286KQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    aiohttp
    requests
  ];

<<<<<<< HEAD
  # All tests require an API key
  doCheck = false;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
