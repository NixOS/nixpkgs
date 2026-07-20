{
  lib,
  buildPythonPackage,
  fetchPypi,
  sexpdata,
  setuptools,
}:

buildPythonPackage rec {
  pname = "epc";
  version = "0.0.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "a14d2ea74817955a20eb00812e3a4630a132897eb4d976420240f1152c0d7d25";
  };

  build-system = [ setuptools ];

  dependencies = [ sexpdata ];
  doCheck = false;

  meta = {
    description = "EPC (RPC stack for Emacs Lisp) implementation in Python";
    homepage = "https://github.com/tkf/python-epc";
    license = lib.licenses.gpl3;
  };
}
