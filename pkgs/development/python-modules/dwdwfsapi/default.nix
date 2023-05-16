{ lib
, buildPythonPackage
, fetchPypi
, requests
, ciso8601
, pythonOlder
}:

buildPythonPackage rec {
  pname = "dwdwfsapi";
<<<<<<< HEAD
  version = "1.0.7";
=======
  version = "1.0.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-7le1F+581JwrBX/C1aaqsDaSpIt0yNsNKiGnJtHUg5s=";
=======
    hash = "sha256-zeSV2acjtSWUYnrMjEBtrSPlXRvrNQRX5SYPYHnaOy0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    requests
    ciso8601
  ];

  # All tests require network access
  doCheck = false;

  pythonImportsCheck = [
    "dwdwfsapi"
  ];

  meta = with lib; {
    description = "Python client to retrieve data provided by DWD via their geoserver WFS API";
    homepage = "https://github.com/stephan192/dwdwfsapi";
<<<<<<< HEAD
    changelog = "https://github.com/stephan192/dwdwfsapi/blob/v${version}/CHANGELOG.md";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ elohmeier ];
  };
}
