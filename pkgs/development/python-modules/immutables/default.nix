{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
<<<<<<< HEAD
=======
, mypy
, typing-extensions
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "immutables";
<<<<<<< HEAD
  version = "0.20";
  format = "setuptools";

  disabled = pythonOlder "3.8";
=======
  version = "0.19";
  format = "setuptools";

  disabled = pythonOlder "3.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "MagicStack";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-fEECtP6WQVzwSzBYX+CbhQtzkB/1WC3OYKXk2XY//xA=";
  };

  postPatch = ''
    rm tests/conftest.py
  '';

  nativeCheckInputs = [
=======
    hash = "sha256-yW+pmAryBp6bvjolN91ACDkk5zxvKfu4nRLQSy71kqs=";
  };

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  nativeCheckInputs = [
    mypy
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pytestCheckHook
  ];

  disabledTests = [
    # Version mismatch
    "testMypyImmu"
  ];

<<<<<<< HEAD
  disabledTestPaths = [
    # avoid dependency on mypy
    "tests/test_mypy.py"
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pythonImportsCheck = [
    "immutables"
  ];

  meta = with lib; {
    description = "An immutable mapping type";
    homepage = "https://github.com/MagicStack/immutables";
<<<<<<< HEAD
    changelog = "https://github.com/MagicStack/immutables/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ catern ];
  };
}
