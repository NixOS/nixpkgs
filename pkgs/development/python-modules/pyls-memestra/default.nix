{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # dependencies
  deprecated,
  memestra,
  python-lsp-server,
}:

buildPythonPackage rec {
  pname = "pyls-memestra";
  version = "0.0.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "QuantStack";
    repo = "pyls-memestra";
    tag = version;
    hash = "sha256-C1d2BibjpoZCPSy39PkdcLiLIwZZG+XTDWXVjTT1Bws=";
  };

  dependencies = [
    deprecated
    memestra
    python-lsp-server
  ];

  # Tests fail because they rely on writing to read-only files
  doCheck = false;

  pythonImportsCheck = [ "pyls_memestra" ];

  meta = {
    description = "Memestra plugin for the Python Language Server";
    homepage = "https://github.com/QuantStack/pyls-memestra";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
