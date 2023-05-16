{ lib
, callPackage
, buildPythonPackage
, fetchFromGitHub
, mkdocs
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "mkdocs-redirects";
<<<<<<< HEAD
  version = "1.2.1";
=======
  version = "1.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "mkdocs";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-zv/tCsC2wrD0iH7Kvlq4nXJMPMGQ7+l68Y/q/x66LBg=";
=======
    hash = "sha256-+Ti+Z5gL5vVlQDt+KRw9nNHHKhRtEfguQe1K001DK9E=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    mkdocs
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "mkdocs_redirects"
  ];

  meta = with lib; {
    description = "Open source plugin for Mkdocs page redirects";
    homepage = "https://github.com/mkdocs/mkdocs-redirects";
    license = licenses.mit;
    maintainers = with maintainers; [ tfc ];
  };
}
