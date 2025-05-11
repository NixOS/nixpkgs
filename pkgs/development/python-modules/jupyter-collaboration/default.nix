{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  hatchling,

  # dependencies
  jupyter-collaboration-ui,
  jupyter-docprovider,
  jupyter-server-ydoc,

  # tests
  callPackage,
}:

buildPythonPackage rec {
  pname = "jupyter-collaboration";
  version = "4.0.2";
  pyproject = true;

  src = fetchPypi {
    pname = "jupyter_collaboration";
    inherit version;
    hash = "sha256-MXKFiuwO36TZGsLlemRUuy04JW/GCWMVdgRBIFTQuiE=";
  };

  build-system = [ hatchling ];

  dependencies = [
    jupyter-collaboration-ui
    jupyter-docprovider
    jupyter-server-ydoc
  ];

  pythonImportsCheck = [ "jupyter_collaboration" ];

  # no tests
  doCheck = false;

  passthru.tests = callPackage ./test.nix { };

  meta = {
    description = "JupyterLab Extension enabling Real-Time Collaboration";
    homepage = "https://github.com/jupyterlab/jupyter_collaboration";
    changelog = "https://github.com/jupyterlab/jupyter_collaboration/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.jupyter ];
  };
}
