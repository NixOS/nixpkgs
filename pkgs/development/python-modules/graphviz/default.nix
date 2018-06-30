{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, graphviz
}:
buildPythonPackage rec {
  pname = "graphviz";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "00rzqsmq25b0say05vix5xivchdvsv83jl2i8pkryqd0nz4bxzvb";
  };

  propagatedBuildInputs = [ graphviz ];

  meta = {
    description = "Simple Python interface for Graphviz";
    homepage = https://github.com/xflr6/graphviz;
    license = lib.licenses.mit;
  };
}

