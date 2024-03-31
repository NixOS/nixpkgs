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
  version = "2.0.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "jupyter_collaboration";
    inherit version;
    hash = "sha256-aQYZGiya7E3blwVkWx6w2Hb2M0v/z9dOMU72EGW4aCg=";
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

  disabledTests = [
    # ExceptionGroup: unhandled errors in a TaskGroup (1 sub-exception)
    "test_dirty"
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
