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
  version = "0.7.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "markqvist";
    repo = "NomadNet";
    tag = version;
    hash = "sha256-/ITBpj5XOn+GYzc2gMg3J8c1eeKWjbyZ4rcXXo4n2Fw=";
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
