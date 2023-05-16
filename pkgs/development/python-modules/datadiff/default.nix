{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "datadiff";
<<<<<<< HEAD
  version = "2.2.0";
=======
  version = "2.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-fOcN/uqMM/HYjbRrDv/ukFzDa023Ofa7BwqC3omB0ws=";
=======
    hash = "sha256-I9QpQyW3sHyUgCYZYfJecTJDNHLaQtqnXG4WeA4p5VE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # Tests are not part of the PyPI releases
  doCheck = false;

  pythonImportsCheck = [
    "datadiff"
  ];

  meta = with lib; {
    description = "Library to provide human-readable diffs of Python data structures";
    homepage = "https://sourceforge.net/projects/datadiff/";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
