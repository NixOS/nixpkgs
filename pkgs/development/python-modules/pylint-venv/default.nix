 { lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pylint-venv";
<<<<<<< HEAD
  version = "3.0.2";
=======
  version = "3.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jgosmann";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-mYG9iZHbA67oJc2sshtV3w8AQaqPsXGqMuLJFI4jAI0=";
=======
    hash = "sha256-GkUdIG+Mp2/POOPJZ/vtONYrd26GB44dxh9455aWZuU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    poetry-core
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pylint_venv"
  ];

  meta = with lib; {
    description = "Module to make pylint respect virtual environments";
    homepage = "https://github.com/jgosmann/pylint-venv/";
<<<<<<< HEAD
    changelog = "https://github.com/jgosmann/pylint-venv/blob/v${version}/CHANGES.md";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
