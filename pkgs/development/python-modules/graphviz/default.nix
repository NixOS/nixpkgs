{ stdenv
, buildPythonPackage
, fetchPypi
, pkgs
}:

buildPythonPackage rec {
  pname = "graphviz";
  version = "0.10.1";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "d311be4fddfe832a56986ac5e1d6e8715d7fcb0208560da79d1bb0f72abef41f";
  };

  propagatedBuildInputs = [ pkgs.graphviz ];

  meta = with stdenv.lib; {
    description = "Simple Python interface for Graphviz";
    homepage = https://github.com/xflr6/graphviz;
    license = licenses.mit;
  };

}
