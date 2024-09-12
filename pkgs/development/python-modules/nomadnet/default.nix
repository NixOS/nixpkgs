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
  version = "0.5.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "markqvist";
    repo = "NomadNet";
    rev = "refs/tags/${version}";
    hash = "sha256-Tx6pcPGYItjTuWGnQc3O+O3HC1gld/2J5T4O63MOD+U=";
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
