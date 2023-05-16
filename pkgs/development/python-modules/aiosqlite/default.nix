{ lib
, aiounittest
, buildPythonPackage
, fetchFromGitHub
, flit-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiosqlite";
<<<<<<< HEAD
  version = "0.19.0";
=======
  version = "0.18.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "omnilib";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-dm7uqG59FP40hcQt+R7qfQiD8P42AYZ2WcH1RoEC5wQ=";
=======
    hash = "sha256-yPGSKqjOz1EY5/V0oKz2EiZ90q2O4TINoXdxHuB7Gqk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    flit-core
  ];

  nativeCheckInputs = [
    aiounittest
    pytestCheckHook
  ];

  # Tests are not pick-up automatically by the hook
  pytestFlagsArray = [
    "aiosqlite/tests/*.py"
  ];

  pythonImportsCheck = [
    "aiosqlite"
  ];

  meta = with lib; {
    description = "Asyncio bridge to the standard sqlite3 module";
    homepage = "https://github.com/jreese/aiosqlite";
    changelog = "https://github.com/omnilib/aiosqlite/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
