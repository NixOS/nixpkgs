{
  lib,
  buildPythonPackage,
  fetchPypi,
  graphviz,
  graphvizPkgs,
  isPyPy,
  python,
  replaceVars,
  setuptools,
}:

buildPythonPackage rec {
  pname = "objgraph";
  version = "3.6.2";
  pyproject = true;

  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ALny9A90IuPH9FphxNr9r4HwP/BknW6uyGbwEDDlGtg=";
  };

  patches = [
    (replaceVars ./hardcode-graphviz-path.patch {
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

  meta = {
    description = "Draws Python object reference graphs with graphviz";
    homepage = "https://mg.pov.lt/objgraph/";
    changelog = "https://github.com/mgedmin/objgraph/blob/${version}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
