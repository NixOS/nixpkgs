{ lib
, buildPythonPackage
, fetchPypi
<<<<<<< HEAD
, pythonOlder
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "funcy";
<<<<<<< HEAD
  version = "2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OWMxXVnUHG8wwEvJEOEKtQo6xKIlhov6lv7tEz3wdcs=";
=======
  version = "1.18";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FUSNGajrzHpYWv56OEoZGG0L1ny/VvtCzR/Q92MT+bI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # No tests
  doCheck = false;

  meta = with lib; {
    description = "Collection of fancy functional tools focused on practicality";
    homepage = "https://funcy.readthedocs.org/";
<<<<<<< HEAD
    changelog = "https://github.com/Suor/funcy/blob/2.0/CHANGELOG";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
=======
    license = licenses.bsd3;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

}
