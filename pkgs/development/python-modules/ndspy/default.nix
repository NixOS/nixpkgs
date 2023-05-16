{ lib
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
=======
, crcmod
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "ndspy";
<<<<<<< HEAD
  version = "4.1.0";
=======
  version = "4.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "RoadrunnerWMC";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-V7phRZCA0WbUpYLgS/4nJbje/JM61RksDUZQ2pnbQyU=";
  };

=======
    sha256 = "0x3sp10had1mq192m7kgjivvs8kpjagxjgj9d4z95dfjhzzbjh70";
  };

  propagatedBuildInputs = [
    crcmod
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "ndspy"
  ];

  preCheck = ''
    cd tests
  '';

  meta = with lib; {
    description = "Python library for many Nintendo DS file formats";
    homepage = "https://github.com/RoadrunnerWMC/ndspy";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ xfix ];
  };
}
