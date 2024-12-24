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
  setuptools,
}:

buildPythonPackage rec {
  pname = "objgraph";
  version = "3.6.2";
  pyproject = true;

  disabled = pythonOlder "3.7" || isPyPy;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ALny9A90IuPH9FphxNr9r4HwP/BknW6uyGbwEDDlGtg=";
  };

  patches = [
    (substituteAll {
      src = ./hardcode-graphviz-path.patch;
      graphviz = graphvizPkgs;
    })
  ];

  build-system = [
    setuptools
  ];

  optional-dependencies = {
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
