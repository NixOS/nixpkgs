{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, pythonOlder
}:

buildPythonPackage rec {
  pname = "chess";
<<<<<<< HEAD
  version = "1.10.0";
=======
  version = "1.9.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "niklasf";
    repo = "python-${pname}";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-jfPg1W9Qp0DlAbMXaFqZ6Ri2zMOW6EKUHwi7Azn/yl0=";
=======
    hash = "sha256-YBABB//53gwJIwrmKJh8W+05hTBhl+49vCYv9//4E+0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  pythonImportsCheck = [
    "chess"
  ];

  checkPhase = ''
    ${python.interpreter} ./test.py -v
  '';

  meta = with lib; {
    description = "A chess library with move generation, move validation, and support for common formats";
    homepage = "https://github.com/niklasf/python-chess";
    changelog = "https://github.com/niklasf/python-chess/blob/v${version}/CHANGELOG.rst";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ smancill ];
  };
}
