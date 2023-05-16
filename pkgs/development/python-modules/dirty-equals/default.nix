{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
<<<<<<< HEAD
, pydantic
, pytest-examples
, pytestCheckHook
, pythonOlder
, pytz
=======
, pytestCheckHook
, pythonOlder
, pytz
, typing-extensions
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "dirty-equals";
<<<<<<< HEAD
  version = "0.7.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";
=======
  version = "0.5.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "samuelcolvin";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-ShbkPGj1whOQ11bFLUSTfvVEVlvc3JUzRDICbBohgMM=";
=======
    hash = "sha256-yYptO6NPhQRlF0T2eXliw2WBms9uqTZVzdYzGj9pCug=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    pytz
<<<<<<< HEAD
  ];

  nativeCheckInputs = [
    pydantic
    pytest-examples
=======
    typing-extensions
  ];

  nativeCheckInputs = [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dirty_equals"
  ];

  meta = with lib; {
    description = "Module for doing dirty (but extremely useful) things with equals";
    homepage = "https://github.com/samuelcolvin/dirty-equals";
<<<<<<< HEAD
    changelog = "https://github.com/samuelcolvin/dirty-equals/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
