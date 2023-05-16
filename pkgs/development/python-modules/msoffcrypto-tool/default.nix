{ lib
, olefile
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, cryptography
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "msoffcrypto-tool";
<<<<<<< HEAD
  version = "5.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";
=======
  version = "5.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "nolze";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-A1TeTE4TMHAb+KtFxTi+b4yTfuEFya8iyzy92dzQ0Z4=";
=======
    hash = "sha256-OrGgY+CEhAHGOOIPYK8OijRdoh0PRelnsKB++ksUIXY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    cryptography
    olefile
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Test fails with AssertionError
    "test_cli"
  ];

  pythonImportsCheck = [
    "msoffcrypto"
  ];

  meta = with lib; {
    description = "Python tool and library for decrypting MS Office files with passwords or other keys";
    homepage = "https://github.com/nolze/msoffcrypto-tool";
    changelog = "https://github.com/nolze/msoffcrypto-tool/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
