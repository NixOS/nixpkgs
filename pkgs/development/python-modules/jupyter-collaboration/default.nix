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
  version = "2.0.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "jupyter_collaboration";
    inherit version;
    hash = "sha256-Uc57kxhaj/DQi5cX+kjV4PGRcFbxWmzc+B248+1VAYI=";
  };

  postPatch = ''
    sed -i "/^timeout/d" pyproject.toml
  '';

  nativeBuildInputs = [
    hatch-jupyter-builder
    hatch-nodejs-version
    hatchling
    jupyterlab
  ];

  propagatedBuildInputs = [
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

  pytestFlagsArray = [
    "-W" "ignore::DeprecationWarning"
  ];

  preCheck = ''
    export HOME=$TEMP
  '';

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "JupyterLab Extension enabling Real-Time Collaboration";
    homepage = "https://github.com/jupyterlab/jupyter_collaboration";
    changelog = "https://github.com/jupyterlab/jupyter_collaboration/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = teams.jupyter.members;
  };
}
