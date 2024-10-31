{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  hatch-jupyter-builder,
  hatch-nodejs-version,
  hatchling,
  jupyterlab,

  # dependencies
  jsonschema,
  jupyter-events,
  jupyter-server,
  jupyter-server-fileid,
  jupyter-ydoc,
  pycrdt,
  pycrdt-websocket,

  # tests
  pytest-jupyter,
  pytestCheckHook,
  websockets,
}:

buildPythonPackage rec {
  pname = "jupyter-collaboration";
  version = "2.1.4";
  pyproject = true;

  src = fetchPypi {
    pname = "jupyter_collaboration";
    inherit version;
    hash = "sha256-YT3wrTQ8imuTK8zeJbwscHtawtqspf1oItGzMMfg5io=";
  };

  postPatch = ''
    sed -i "/^timeout/d" pyproject.toml
  '';

  build-system = [
    hatch-jupyter-builder
    hatch-nodejs-version
    hatchling
    jupyterlab
  ];

  dependencies = [
    jsonschema
    jupyter-events
    jupyter-server
    jupyter-server-fileid
    jupyter-ydoc
    pycrdt
    pycrdt-websocket
  ];

  nativeCheckInputs = [
    pytest-jupyter
    pytestCheckHook
    websockets
  ];

  pythonImportsCheck = [ "jupyter_collaboration" ];

  preCheck = ''
    export HOME=$TEMP
  '';

  pytestFlagsArray = [ "-Wignore::DeprecationWarning" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "JupyterLab Extension enabling Real-Time Collaboration";
    homepage = "https://github.com/jupyterlab/jupyter_collaboration";
    changelog = "https://github.com/jupyterlab/jupyter_collaboration/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = lib.teams.jupyter.members;
  };
}
