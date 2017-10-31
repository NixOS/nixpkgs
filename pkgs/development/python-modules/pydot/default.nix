{ lib
, buildPythonPackage
, fetchPypi
, chardet
, pyparsing
, graphviz
}:

buildPythonPackage rec {
  pname = "pydot";
  version = "1.2.3";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "edb5d3f249f97fbd9c4bb16959e61bc32ecf40eee1a9f6d27abe8d01c0a73502";
  };
  checkInputs = [ chardet ];
  # No tests in archive
  doCheck = false;
  propagatedBuildInputs = [pyparsing graphviz];
  meta = {
    homepage = https://github.com/erocarrera/pydot;
    description = "Allows to easily create both directed and non directed graphs from Python";
    licenses = with lib.licenses; [ mit ];
  };
}