{
  lib,
  buildPythonPackage,
  fetchPypi,
  sexpdata,
}:

buildPythonPackage rec {
  pname = "epc";
  version = "0.0.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oU0up0gXlVog6wCBLjpGMKEyiX602XZCAkDxFSwNfSU=";
  };

  propagatedBuildInputs = [ sexpdata ];
  doCheck = false;

  meta = with lib; {
    description = "EPC (RPC stack for Emacs Lisp) implementation in Python";
    homepage = "https://github.com/tkf/python-epc";
    license = licenses.gpl3;
  };
}
