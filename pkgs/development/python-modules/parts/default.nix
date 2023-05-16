{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
<<<<<<< HEAD
, wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "parts";
<<<<<<< HEAD
  version = "1.7.0";
=======
  version = "1.6.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-TbcFgWKKgHXFyi1NqwVy1ITGHESb4ZusivOpFWazN1s=";
=======
    hash = "sha256-anjD/UfKyfgfJh16cR8ZSUjdAmswO3cdMYKRczyMN3A=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools
<<<<<<< HEAD
    wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "parts"
  ];

  meta = with lib; {
    description = "Library for common list functions related to partitioning lists";
    homepage = "https://github.com/lapets/parts";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
