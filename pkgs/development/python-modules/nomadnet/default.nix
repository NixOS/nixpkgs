{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  lxmf,
  msgpack,
  qrcode,
  rns,
  setuptools,
  urwid,
}:

buildPythonPackage (finalAttrs: {
  pname = "nomadnet";
  version = "0.9.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "markqvist";
    repo = "NomadNet";
    tag = finalAttrs.version;
    hash = "sha256-qLe9fnIE9kY9JerAAH318dq1SOshP9xX3l/2c91fnSA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    rns
    lxmf
    msgpack
    urwid
    qrcode
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "nomadnet" ];

  meta = {
    description = "Off-grid, resilient mesh communication";
    homepage = "https://github.com/markqvist/NomadNet";
    changelog = "https://github.com/markqvist/NomadNet/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "nomadnet";
  };
})
