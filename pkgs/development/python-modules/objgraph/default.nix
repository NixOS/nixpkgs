{ lib
, buildPythonPackage
, fetchPypi
, isPyPy
, substituteAll
, graphvizPkgs
, graphviz
, mock
}:

buildPythonPackage rec {
  pname = "objgraph";
  version = "3.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4752ca5bcc0e0512e41b8cc4d2780ac2fd3b3eabd03b7e950a5594c06203dfc4";
  };

  # Tests fail with PyPy.
  disabled = isPyPy;

  patches = [
    (substituteAll {
      src = ./hardcode-graphviz-path.patch;
      graphviz = graphvizPkgs;
    })
  ];

  propagatedBuildInputs = [ graphviz ];

  nativeCheckInputs = [ mock ];

  meta = with lib; {
    description = "Draws Python object reference graphs with graphviz";
    homepage = "https://mg.pov.lt/objgraph/";
    license = licenses.mit;
  };

}
