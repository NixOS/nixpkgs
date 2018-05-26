{ lib
, buildPythonPackage
, fetchPypi
, chardet
, pyparsing
, graphviz
}:

buildPythonPackage rec {
  pname = "pydot";
  version = "1.2.4";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "92d2e2d15531d00710f2d6fb5540d2acabc5399d464f2f20d5d21073af241eb6";
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
