{ lib
, buildPythonPackage
, fetchPypi
, graphviz
, graphvizPkgs
, isPyPy
, pytestCheckHook
, pythonOlder
, substituteAll
}:

buildPythonPackage rec {
  pname = "objgraph";
  version = "3.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.5" || isPyPy;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-R1LKW8wOBRLkG4zE0ngKwv07PqvQO36VClWUwGID38Q=";
  };

  patches = [
    (substituteAll {
      src = ./hardcode-graphviz-path.patch;
      graphviz = graphvizPkgs;
    })
  ];

  propagatedBuildInputs = [
    graphviz
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "objgraph"
  ];

  pytestFlagsArray = [
    "tests.py"
  ];

  meta = with lib; {
    description = "Draws Python object reference graphs with graphviz";
    homepage = "https://mg.pov.lt/objgraph/";
    changelog = "https://github.com/mgedmin/objgraph/blob/${version}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
