{ stdenv
, buildPythonPackage
, fetchPypi
, pkgs
, isPyPy
}:

buildPythonPackage rec {
  pname = "objgraph";
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "841de52715774ec1d0e97d9b4462d6e3e10406155f9b61f54ba7db984c45442a";
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
