{ lib
, fetchFromGitHub
, buildPythonPackage
, typing
, pytestCheckHook
, pythonAtLeast
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mypy-extensions";
<<<<<<< HEAD
  version = "1.0.0";
=======
  version = "0.4.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "python";
    repo = "mypy_extensions";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-gOfHC6dUeBE7SsWItpUHHIxW3wzhPM5SuGW1U8P7DD0=";
=======
    hash = "sha256-JjhbxX5DBAbcs1o2fSWywz9tot792q491POXiId+NyI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = lib.optional (pythonOlder "3.5") typing;

  # make the testsuite run with pytest, so we can disable individual tests
  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "tests/testextensions.py"
  ];

  disabledTests = lib.optionals (pythonAtLeast "3.11") [
    # https://github.com/python/mypy_extensions/issues/24
    "test_typeddict_errors"
  ];

  pythonImportsCheck = [
    "mypy_extensions"
  ];

  meta = with lib; {
    description = "Experimental type system extensions for programs checked with the mypy typechecker";
    homepage = "https://www.mypy-lang.org";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ martingms lnl7 ];
=======
    maintainers = with maintainers; [ martingms lnl7 SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
