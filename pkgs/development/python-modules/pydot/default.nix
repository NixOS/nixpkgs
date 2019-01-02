{ lib
, buildPythonPackage
, fetchPypi
, chardet
, pyparsing
, graphviz
}:

buildPythonPackage rec {
  pname = "pydot";
  version = "1.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "00az4cbf8bv447lkk9xi6pjm7gcc7ia33y4pm71fwfwis56rv76l";
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
