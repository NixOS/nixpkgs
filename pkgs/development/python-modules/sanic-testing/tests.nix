{ buildPythonPackage
<<<<<<< HEAD
=======
, sanic
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, sanic-testing
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage {
  pname = "sanic-testing-tests";
  inherit (sanic-testing) version;

  src = sanic-testing.testsout;
<<<<<<< HEAD
  format = "other";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  dontBuild = true;
  dontInstall = true;

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
<<<<<<< HEAD
    sanic-testing
=======
    sanic
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  pythonImportsCheck = [
    "sanic_testing"
  ];
}
