{ stdenv
, buildPythonPackage
, fetchPypi
, isPyPy
, substituteAll
, graphvizPkg
, graphviz
, mock
}:

buildPythonPackage rec {
  pname = "objgraph";
  version = "3.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bf29512d7f8b457b53fa0722ea59f516abb8abc59b78f97f0ef81394a0c615a7";
  };

  # Tests fail with PyPy.
  disabled = isPyPy;

  patches = [
    (substituteAll {
      src = ./hardcode-graphviz-path.patch;
      graphviz = graphvizPkg;
    })
  ];

  propagatedBuildInputs = [ graphviz ];

  checkInputs = [ mock ];

  meta = with stdenv.lib; {
    description = "Draws Python object reference graphs with graphviz";
    homepage = https://mg.pov.lt/objgraph/;
    license = licenses.mit;
  };

}
