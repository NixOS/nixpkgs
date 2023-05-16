{ lib
, buildPythonPackage
, fetchPypi
, pytest-mock
, pytestCheckHook
<<<<<<< HEAD
, pythonAtLeast
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pythonOlder
}:

buildPythonPackage rec {
  pname = "restrictedpython";
<<<<<<< HEAD
  version = "6.2";
=======
  version = "6.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "RestrictedPython";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-23Prfjs5ZQ8NIdEMyN2pwOKYbmIclLDF3jL7De46CK8=";
=======
    hash = "sha256-QFzwvZ7sLxmxMmtfSCKO/lbWWQtOkYJrjMOyzUAKlq0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

<<<<<<< HEAD
  disabledTests = lib.optionals (pythonAtLeast "3.11") [
    "test_compile__compile_restricted_exec__5"
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pythonImportsCheck = [
    "RestrictedPython"
  ];

  meta = with lib; {
    description = "Restricted execution environment for Python to run untrusted code";
    homepage = "https://github.com/zopefoundation/RestrictedPython";
    changelog = "https://github.com/zopefoundation/RestrictedPython/blob/${version}/CHANGES.rst";
    license = licenses.zpl21;
    maintainers = with maintainers; [ juaningan ];
  };
}
