{ lib
, buildPythonPackage
, fetchPypi
, nulltype
, python-dateutil
, urllib3
, pythonOlder
}:

buildPythonPackage rec {
  pname = "plaid-python";
<<<<<<< HEAD
  version = "15.5.0";
=======
  version = "13.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-zI3fOd1IcnXS5moM3mHl/1qzrAHnxoVrFg1GBCqiA10=";
=======
    hash = "sha256-xe0HK6S612q/DiNLGpBqhfTg1RVvzeeez5Y0ot/+Tqk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    nulltype
    python-dateutil
    urllib3
  ];

  # Tests require a Client IP
  doCheck = false;

  pythonImportsCheck = [
    "plaid"
  ];

  meta = with lib; {
    description = "Python client library for the Plaid API and Link";
    homepage = "https://github.com/plaid/plaid-python";
    changelog = "https://github.com/plaid/plaid-python/blob/master/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ bhipple ];
  };
}
