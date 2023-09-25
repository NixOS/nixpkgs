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
  version = "0.3.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "markqvist";
    repo = "NomadNet";
    rev = "refs/tags/${version}";
    hash = "sha256-w7NQH4CEfYQ4iwPtLQO5mYRnfWQbPuxb/qXRBP0V56Y=";
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
