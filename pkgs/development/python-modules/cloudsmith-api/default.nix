{ lib
, buildPythonPackage
, certifi
, fetchPypi
, python-dateutil
, pythonOlder
, six
, urllib3
}:

buildPythonPackage rec {
  pname = "cloudsmith-api";
<<<<<<< HEAD
  version = "2.0.7";
=======
  version = "2.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "wheel";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "cloudsmith_api";
    inherit format version;
<<<<<<< HEAD
    hash = "sha256-Vw5ifMJ+gwXecYjSe8QKkq+RtrBWxx3B/LdA80ZxuxU=";
=======
    hash = "sha256-wFSHlUdZTARsAV3igVXThrXoGsPUaZyzXBJCSJFZYYQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    certifi
    python-dateutil
    six
    urllib3
  ];

  # Wheels have no tests
  doCheck = false;

  pythonImportsCheck = [
    "cloudsmith_api"
  ];

  meta = with lib; {
    description = "Cloudsmith API Client";
    homepage = "https://github.com/cloudsmith-io/cloudsmith-api";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ jtojnar ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
