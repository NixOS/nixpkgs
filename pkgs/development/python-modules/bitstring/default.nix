{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "bitstring";
<<<<<<< HEAD
  version = "4.0.2";
=======
  version = "4.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "scott-griffiths";
    repo = pname;
    rev = "bitstring-${version}";
<<<<<<< HEAD
    hash = "sha256-LghfDjf/Z1dEU0gjH1cqMb04ChnW+aGDjmN+RAhMWW8=";
=======
    hash = "sha256-eHP20F9PRe9ZNXjcDcsI3iFVswA6KtRWhBMAT7dkCv0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "bitstring" ];

  meta = with lib; {
    description = "Module for binary data manipulation";
    homepage = "https://github.com/scott-griffiths/bitstring";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor ];
  };
}
