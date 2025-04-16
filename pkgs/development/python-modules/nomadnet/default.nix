{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  lxmf,
  pythonOlder,
  qrcode,
  rns,
  setuptools,
  urwid,
}:

buildPythonPackage rec {
  pname = "nomadnet";
  version = "0.6.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "markqvist";
    repo = "NomadNet";
    tag = version;
    hash = "sha256-HBNZvU4ZCLgEn8ul1iflaY18novZMnn8GIojriX/ej0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    rns
    lxmf
    urwid
    qrcode
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "nomadnet" ];

  meta = with lib; {
    description = "Off-grid, resilient mesh communication";
    homepage = "https://github.com/markqvist/NomadNet";
    changelog = "https://github.com/markqvist/NomadNet/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "nomadnet";
  };
}
