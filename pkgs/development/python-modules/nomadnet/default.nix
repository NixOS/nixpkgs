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
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "markqvist";
    repo = "NomadNet";
    tag = finalAttrs.version;
    hash = "sha256-uNchcz9kiLX2nUNRC2rTMv7my+19ylZrHTGWbonziFc=";
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
