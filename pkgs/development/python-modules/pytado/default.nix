{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, requests
<<<<<<< HEAD
, pythonOlder
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "pytado";
<<<<<<< HEAD
  version = "0.17.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
  version = "0.13.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "wmalgadey";
    repo = "PyTado";
<<<<<<< HEAD
    rev = "refs/tags/${version}";
    sha256 = "sha256-w1qtSEpnZCs7+M/0Gywz9AeMxUzz2csHKm9SxBKzmz4=";
=======
    # Upstream hasn't tagged 0.13.0 yet
    rev = "2a243174e9ae01ef7adae940ecc6e340992ab28d";
    sha256 = "Y1FxEzs/AF0ZTPdOK/1v+2U2fidfu+AmZbPddJCWIFc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "PyTado"
  ];

  meta = with lib; {
    description = "Python binding for Tado web API";
    homepage = "https://github.com/wmalgadey/PyTado";
<<<<<<< HEAD
    changelog = "https://github.com/wmalgadey/PyTado/releases/tag/${version}";
    license = licenses.gpl3Only;
=======
    license = licenses.gpl3;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ ];
  };
}
