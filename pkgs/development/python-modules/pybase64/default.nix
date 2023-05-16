{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pybase64";
<<<<<<< HEAD
  version = "1.3.0";
=======
  version = "1.2.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-1MZHKrAITr1O4AW7mFFym9xk2PYsb65b2wdrICn0iO4=";
=======
    hash = "sha256-dtB035p7mJs1iZJqsZRmd7uzmez+IwcUsTFX4mM2Ee0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pybase64" ];

  meta = with lib; {
    description = "Fast Base64 encoding/decoding";
    homepage = "https://github.com/mayeut/pybase64";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
