{ lib
, buildPythonPackage
, fetchPypi
, chardet
, pyparsing
, graphviz
}:

buildPythonPackage rec {
  pname = "pydot";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02yp2k7p1kh0azwd932jhvfc3nxxdv9dimh7hdgwdnmp05yms6cq";
  };
  checkInputs = [ chardet ];
  # No tests in archive
  doCheck = false;
  propagatedBuildInputs = [pyparsing graphviz];
  meta = {
    homepage = https://github.com/erocarrera/pydot;
    description = "Allows to easily create both directed and non directed graphs from Python";
    license = lib.licenses.mit;
  };
}
