{
  lib,
  buildPythonPackage,
  fetchPypi,
  graphviz,
  graphvizPkgs,
  isPyPy,
  python,
  pythonOlder,
  substituteAll,
}:

buildPythonPackage rec {
  pname = "objgraph";
  version = "3.6.1";
  format = "setuptools";

  disabled = pythonOlder "3.7" || isPyPy;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/pbHQUe7yq6GZbOW5TiL3MMZfe67pOY4HwUgLuW0U6c=";
  };

  patches = [
    (substituteAll {
      src = ./hardcode-graphviz-path.patch;
      graphviz = graphvizPkgs;
    })
  ];

  passthru.optional-dependencies = {
    ipython = [ graphviz ];
  };

  pythonImportsCheck = [ "objgraph" ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} tests.py
    runHook postCheck
  '';

  meta = with lib; {
    description = "Draws Python object reference graphs with graphviz";
    homepage = "https://mg.pov.lt/objgraph/";
    changelog = "https://github.com/mgedmin/objgraph/blob/${version}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
