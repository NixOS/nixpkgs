{ lib
, buildPythonPackage
, docutils
, fetchPypi
, pybtex
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pybtex-docutils";
<<<<<<< HEAD
  version = "1.0.3";
=======
  version = "1.0.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-On69+StZPgDowcU4qpogvKXZLYQjESRxWsyWTVHZPGs=";
=======
    hash = "sha256-Q6o1O21Jj9WsMPAHOpjjMtBh00/mGdPVDRdh+P1KoBY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [
    docutils
    pybtex
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pybtex_docutils"
  ];

  meta = with lib; {
    description = "A docutils backend for pybtex";
    homepage = "https://github.com/mcmtroffaes/pybtex-docutils";
    license = licenses.mit;
  };
}
