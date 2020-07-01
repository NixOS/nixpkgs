{ stdenv
, buildPythonPackage
, fetchPypi
, sexpdata
}:

buildPythonPackage rec {
  pname = "epc";
  version = "0.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a14d2ea74817955a20eb00812e3a4630a132897eb4d976420240f1152c0d7d25";
  };

  propagatedBuildInputs = [ sexpdata ];
  doCheck = false;

  meta = with stdenv.lib; {
    description = "EPC (RPC stack for Emacs Lisp) implementation in Python";
    homepage = "https://github.com/tkf/python-epc";
    license = licenses.gpl3;
  };

}
