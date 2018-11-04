{ stdenv
, buildPythonPackage
, fetchPypi
, pkgs
, isPyPy
}:

buildPythonPackage rec {
  pname = "objgraph";
  version = "3.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4a0c2c6268e10a9e8176ae054ff3faac9a432087801e1f95c3ebbe52550295a0";
  };

  # Tests fail with PyPy.
  disabled = isPyPy;

  propagatedBuildInputs = [pkgs.graphviz];

  meta = with stdenv.lib; {
    description = "Draws Python object reference graphs with graphviz";
    homepage = https://mg.pov.lt/objgraph/;
    license = licenses.mit;
  };

}
