{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "markupsafe";
<<<<<<< HEAD
  version = "2.1.3";
=======
  version = "2.1.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "MarkupSafe";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-r1mO0y1q6G8bdHuCeDlYsaSrj2F7Bv5oeVx/Amq73K0=";
=======
    hash = "sha256-q8q8jCsmA21i1MdGOBpvfPYKr8xlMZitZ4MGmGsJRQ0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "markupsafe" ];

  meta = with lib; {
<<<<<<< HEAD
    changelog = "https://markupsafe.palletsprojects.com/en/${versions.majorMinor version}.x/changes/#version-${replaceStrings [ "." ] [ "-" ] version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "Implements a XML/HTML/XHTML Markup safe string";
    homepage = "https://palletsprojects.com/p/markupsafe/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ domenkozar ];
  };
}
