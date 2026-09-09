{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  hatchling,
  hatch-jupyter-builder,
  jupyter-builder,

  # passthru
  jupyter-collaboration,
}:

buildPythonPackage (finalAttrs: {
  pname = "jupyter-collaboration-ui";
  version = "3.0.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "jupyter_collaboration_ui";
    inherit (finalAttrs) version;
    hash = "sha256-X2o6WEb5tAk6EYV212cx/fAa3SL7F5WmKyn9Pd/dExQ=";
  };

  build-system = [
    hatchling
    hatch-jupyter-builder
    jupyter-builder
  ];

  pythonImportsCheck = [ "jupyter_collaboration_ui" ];

  # no tests
  doCheck = false;

  passthru.tests = jupyter-collaboration;

  meta = {
    description = "JupyterLab/Jupyter Notebook 7+ extension providing user interface integration for real time collaboration";
    homepage = "https://github.com/jupyterlab/jupyter-collaboration/tree/main/projects/jupyter-collaboration-ui";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.jupyter ];
  };
})
