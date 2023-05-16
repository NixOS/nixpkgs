{ lib
, attrs
, buildPythonPackage
, fetchFromGitHub
, voluptuous
, pythonOlder
}:

buildPythonPackage rec {
  pname = "hatasmota";
<<<<<<< HEAD
  version = "0.7.3";
=======
  version = "0.6.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "emontnemery";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-lsb92JsqIhq7zaNaolgV8dtSFIq+Enklb6hlBvT7/Ig=";
=======
    hash = "sha256-DqXGvn7vYC3SXOM/u+nMUshgBUe0O6Dcffaxh9vFohk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    attrs
    voluptuous
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "hatasmota"
  ];

  meta = with lib; {
    description = "Python module to help parse and construct Tasmota MQTT messages";
    homepage = "https://github.com/emontnemery/hatasmota";
    changelog = "https://github.com/emontnemery/hatasmota/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
