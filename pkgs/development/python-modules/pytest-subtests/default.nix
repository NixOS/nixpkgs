{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
<<<<<<< HEAD
, setuptools
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pytest-subtests";
<<<<<<< HEAD
  version = "0.11.0";
  format = "pyproject";
=======
  version = "0.10.0";
  format = "setuptools";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-UYZciEV1RfUftyARlC8KPGkB7p4ky/ttG53BNIuvvjc=";
  };

  nativeBuildInputs = [
    setuptools
=======
    hash = "sha256-2ZYaZ8F5HoweMtznpw7R5U87HmQQh/IJTy03CHq3+xc=";
  };

  nativeBuildInputs = [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pytest_subtests"
  ];

  meta = with lib; {
    description = "Pytest plugin for unittest subTest() support and subtests fixture";
    homepage = "https://github.com/pytest-dev/pytest-subtests";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
