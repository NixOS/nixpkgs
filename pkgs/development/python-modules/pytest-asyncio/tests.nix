{ buildPythonPackage
, flaky
, hypothesis
, pytest-asyncio
, pytest-trio
, pytestCheckHook
}:

<<<<<<< HEAD
buildPythonPackage {
  pname = "pytest-asyncio-tests";
  inherit (pytest-asyncio) version;

  format = "other";

=======
buildPythonPackage rec {
  pname = "pytest-asyncio-tests";
  inherit (pytest-asyncio) version;

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = pytest-asyncio.testout;

  dontBuild = true;
  dontInstall = true;

  propagatedBuildInputs = [
    pytest-asyncio
  ];

  nativeCheckInputs = [
    flaky
    hypothesis
    pytest-trio
    pytestCheckHook
  ];
}
