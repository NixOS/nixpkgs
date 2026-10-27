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
  version = "1.4.4";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) version pname;
    hash = "sha256-f9QzuJB1WzGHvEQNUC9v1Q7JtZu/ZVKD3/RNQnTPGzU=";
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
