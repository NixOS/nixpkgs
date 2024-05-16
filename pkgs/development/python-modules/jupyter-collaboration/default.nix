{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, hatch-jupyter-builder
, hatch-nodejs-version
, hatchling
, jsonschema
, jupyter-events
, jupyter-server
, jupyter-server-fileid
, jupyter-ydoc
, jupyterlab
, pycrdt-websocket
, pytest-jupyter
, pytestCheckHook
, websockets
}:

buildPythonPackage rec {
  pname = "jupyter-collaboration";
  version = "2.1.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "jupyter_collaboration";
    inherit version;
    hash = "sha256-T1DCXG2BEmwW3q+S0r14o5svy4ZpDc5pa0AGt0DXHB8=";
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
    pycrdt-websocket
  ];

  nativeCheckInputs = [
    pytest-jupyter
    pytestCheckHook
    websockets
  ];

  pythonImportsCheck = [
    "jupyter_collaboration"
  ];

  preCheck = ''
    export HOME=$TEMP
  '';

  pytestFlagsArray = [
    "-Wignore::DeprecationWarning"
  ];

  disabledTests = [
    # ExceptionGroup: unhandled errors in a TaskGroup (1 sub-exception)
    "test_dirty"
    # causes a hang
    "test_rooms"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "JupyterLab Extension enabling Real-Time Collaboration";
    homepage = "https://github.com/jupyterlab/jupyter_collaboration";
    changelog = "https://github.com/jupyterlab/jupyter_collaboration/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = teams.jupyter.members;
  };
}
