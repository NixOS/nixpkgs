{
  lib,
  buildPythonPackage,
  fetchPypi,
  sexpdata,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "epc";
  version = "0.0.5";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-oU0up0gXlVog6wCBLjpGMKEyiX602XZCAkDxFSwNfSU=";
  };

  build-system = [ setuptools ];

  dependencies = [ sexpdata ];
  doCheck = false;

  meta = {
    description = "EPC (RPC stack for Emacs Lisp) implementation in Python";
    homepage = "https://github.com/tkf/python-epc";
    license = lib.licenses.gpl3Only;
  };
})
