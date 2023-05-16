{ lib
, buildPythonPackage
, fetchFromGitHub
, pyopenssl
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "requests-pkcs12";
<<<<<<< HEAD
  version = "1.18";
=======
  version = "1.15";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "m-click";
    repo = "requests_pkcs12";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-jZWaTcPM4EO8e+eVpYU8fQ4H53OzlaMUsT/d2DWuU+0=";
=======
    hash = "sha256-xk8+oERonZWzxKEmZutfvovzVOz9ZP5O83cMDTz9i3Y=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    requests
    pyopenssl
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "requests_pkcs12"
  ];

  meta = with lib; {
    description = "PKCS#12 support for the Python requests library";
    homepage = "https://github.com/m-click/requests_pkcs12";
    license = with licenses; [ isc ];
    maintainers = with maintainers; [ fab ];
  };
}
