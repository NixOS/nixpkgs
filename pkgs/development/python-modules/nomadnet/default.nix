{ lib
, buildPythonPackage
, rns
, fetchFromGitHub
, lxmf
, urwid
, pythonOlder
, qrcode
}:

buildPythonPackage rec {
  pname = "nomadnet";
<<<<<<< HEAD
  version = "0.3.6";
=======
  version = "0.3.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "markqvist";
    repo = "NomadNet";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-3b6uwojekWthH5AsAVfS/ue+yAoIMac1LQff1mrM9PM=";
=======
    hash = "sha256-SPQ/3ntdD+EBW2YZJKfg2lornlg1ktnvTd1PNAqNSIg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    rns
    lxmf
    urwid
    qrcode
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "nomadnet"
  ];

  meta = with lib; {
    description = "Off-grid, resilient mesh communication";
    homepage = "https://github.com/markqvist/NomadNet";
    changelog = "https://github.com/markqvist/NomadNet/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
