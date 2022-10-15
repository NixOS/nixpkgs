{ lib
, buildPythonPackage
, rns
, fetchFromGitHub
, lxmf
, urwid
, pythonOlder
}:

buildPythonPackage rec {
  pname = "nomadnet";
  version = "0.2.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "markqvist";
    repo = "NomadNet";
    rev = version;
    hash = "sha256-SfKIbgt+F4CPA5r5NHjgPXOiq3+3UtvzEQfXkmN1VR0=";
  };

  propagatedBuildInputs = [
    rns
    lxmf
    urwid
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "nomadnet"
  ];

  meta = with lib; {
    description = "Off-grid, resilient mesh communication";
    homepage = "https://github.com/markqvist/NomadNet";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
