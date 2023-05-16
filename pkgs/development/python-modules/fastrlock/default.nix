{ lib
, buildPythonPackage
, cython
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "fastrlock";
<<<<<<< HEAD
  version = "0.8.2";
=======
  version = "0.8.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "scoder";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-2h+rhP/EVMG3IkJVkE74p4GeBTwV3BS7fUkKpwedr2k=";
=======
    hash = "sha256-KYJd1wGJo+z34cY0YfsRbpC9IsQY/VJqycGpMmLmaVk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cython
  ];

  # Todo: Check why the tests have an import error
  doCheck = false;

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "fastrlock"
  ];

  meta = with lib; {
    description = "RLock implementation for CPython";
    homepage = "https://github.com/scoder/fastrlock";
    license = licenses.mit;
    maintainers = with maintainers; [ hyphon81 ];
  };
}
