{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
, pythonOlder
, setuptools
, wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "pyinstrument";
<<<<<<< HEAD
  version = "4.5.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";
=======
  version = "4.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "joerick";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-VL/JzgMxn5zABfmol+5oofR1RjyxTdzvUi6JnwsSFao=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

=======
    rev = "v${version}";
    hash = "sha256-0GbJkYBgSOIZrHSKM93SW93jXD+ieYN6A01kWoFbyvQ=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # Module import recursion
  doCheck = false;

  pythonImportsCheck = [
    "pyinstrument"
  ];

  meta = with lib; {
    description = "Call stack profiler for Python";
    homepage = "https://github.com/joerick/pyinstrument";
<<<<<<< HEAD
    changelog = "https://github.com/joerick/pyinstrument/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
