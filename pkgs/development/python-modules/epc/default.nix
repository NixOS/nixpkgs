{ stdenv
, buildPythonPackage
, fetchPypi
, sexpdata
}:

buildPythonPackage rec {
  pname = "epc";
  version = "0.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "30b594bd4a4acbd5bda0d3fa3d25b4e8117f2ff8f24d2d1e3e36c90374f3c55e";
  };

  propagatedBuildInputs = [ sexpdata ];
  doCheck = false;

  meta = with stdenv.lib; {
    description = "EPC (RPC stack for Emacs Lisp) implementation in Python";
    homepage = "https://github.com/tkf/python-epc";
    license = licenses.gpl3;
  };

}
