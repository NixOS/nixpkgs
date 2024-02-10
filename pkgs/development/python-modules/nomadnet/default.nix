{ lib
, buildPythonPackage
, fetchFromGitHub
, lxmf
, pythonOlder
, qrcode
, rns
, setuptools
, urwid
}:

buildPythonPackage rec {
  pname = "nomadnet";
  version = "0.4.5";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "markqvist";
    repo = "NomadNet";
    rev = "refs/tags/${version}";
    hash = "sha256-+w/Earu76mMJFp8ALvaDEkZOGJqlKbO7jfpW/xxvd1o=";
  };

  nativeBuildInputs = [
    setuptools
  ];

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
