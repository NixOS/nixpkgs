{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
<<<<<<< HEAD
=======
, pytest-mypy
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pythonOlder
, redis
}:

buildPythonPackage rec {
  pname = "portalocker";
  version = "2.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Ay6B1TSojsFzbQP3gLoHPwR6BsR4sG4pN0hvM06VXFE=";
  };

  propagatedBuildInputs = [
    redis
  ];

  nativeCheckInputs = [
    pytestCheckHook
<<<<<<< HEAD
=======
    pytest-mypy
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  disabledTests = [
    "test_combined" # no longer compatible with setuptools>=58
  ];

  pythonImportsCheck = [
    "portalocker"
  ];

  meta = with lib; {
    description = "A library to provide an easy API to file locking";
    homepage = "https://github.com/WoLpH/portalocker";
    license = licenses.psfl;
    maintainers = with maintainers; [ jonringer ];
<<<<<<< HEAD
=======
    platforms = platforms.unix; # Windows has a dependency on pypiwin32
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
