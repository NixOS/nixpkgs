{
  lib,
  buildPythonPackage,
  fetchPypi,
  lxmf,
  msgpack,
  qrcode,
  rns,
  setuptools,
  urwid,
}:

buildPythonPackage (finalAttrs: {
  pname = "nomadnet";
  version = "1.4.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) version pname;
    hash = "sha256-7sbmRBmjW01vH2x5+nPUFswRElO8Q/+/p2++Nf1X90c=";
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
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      drupol
      fab
    ];
    mainProgram = "nomadnet";
  };
})
