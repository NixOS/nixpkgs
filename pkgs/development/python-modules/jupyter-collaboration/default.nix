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
  version = "3.1.0";
  pyproject = true;

  src = fetchPypi {
    pname = "jupyter_collaboration";
    inherit version;
    hash = "sha256-BDmG5vzdikFh342XFqk92q/smidKqbUDWEx6gORh7p8=";
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
    maintainers = lib.teams.jupyter.members;
  };
}
