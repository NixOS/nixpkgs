{ lib
, buildPythonPackage
, fetchPypi
, setuptools
<<<<<<< HEAD
, wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, bitlist
, pythonOlder
}:

buildPythonPackage rec {
  pname = "fountains";
<<<<<<< HEAD
  version = "2.2.0";
=======
  version = "2.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-MhOQ4pemxmjfp7Uy5hLA8i8BBI5QbvD4EjEcKMM/u3I=";
=======
    hash = "sha256-gYVguXMVrXxra/xy+R4RXVk9yDGKiKE8u3qWUk8sjt4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools
<<<<<<< HEAD
    wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  propagatedBuildInputs = [
    bitlist
  ];

  # Module has no test
  doCheck = false;

  pythonImportsCheck = [
    "fountains"
  ];

  meta = with lib; {
    description = "Python library for generating and embedding data for unit testing";
    homepage = "https://github.com/reity/fountains";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
