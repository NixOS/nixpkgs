{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, python
, pytestCheckHook
, pythonOlder
, six
}:

buildPythonPackage rec {
  pname = "funcparserlib";
<<<<<<< HEAD
  version = "1.0.1";
=======
  version = "1.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "vlasovskikh";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-LE9ItCaEzEGeahpM3M3sSnDBXEr6uX5ogEkO5x2Jgzc=";
=======
    hash = "sha256-moWaOzyF/yhDQCLEp7bc0j8wNv7FM7cvvpCwon3j+gI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    poetry-core
  ];

  nativeCheckInputs = [
    pytestCheckHook
    six
  ];

  pythonImportsCheck = [
    "funcparserlib"
  ];

  meta = with lib; {
    description = "Recursive descent parsing library based on functional combinators";
    homepage = "https://github.com/vlasovskikh/funcparserlib";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
