{ lib
, buildPythonPackage
, fetchPypi
, pytest
<<<<<<< HEAD
, pytestCheckHook
, pytest-flakes
=======
, pytest-flakes
, tox
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "pytest-quickcheck";
  version = "0.9.0";
<<<<<<< HEAD
  format = "setuptools";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UFF8ldnaImXU6al4kGjf720mbwXE6Nut9VlvNVrMVoY=";
  };

<<<<<<< HEAD
  propagatedBuildInputs = [
    pytest
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-flakes
  ];
=======
  buildInputs = [ pytest ];

  propagatedBuildInputs = [ pytest-flakes tox ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    license = licenses.asl20;
    homepage = "https://pypi.python.org/pypi/pytest-quickcheck";
    description = "pytest plugin to generate random data inspired by QuickCheck";
    maintainers = with maintainers; [ onny ];
<<<<<<< HEAD
=======
    # Pytest support > 6.0 missing
    # https://github.com/t2y/pytest-quickcheck/issues/17
    broken = true;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
