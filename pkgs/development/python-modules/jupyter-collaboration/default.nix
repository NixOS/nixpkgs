{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, hatch-jupyter-builder
, hatch-nodejs-version
, hatchling
, pythonRelaxDepsHook
, jupyter-events
, jupyter-server
, jupyter-server-fileid
, jupyter-ydoc
, jupyterlab
, ypy-websocket
, pytest-asyncio
, pytest-jupyter
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jupyter-collaboration";
  version = "1.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "jupyter_collaboration";
    inherit version;
    hash = "sha256-3OxduJ93TmbS/fKSKmVXs5vj2IZMX5MqKPTeGklFCbM=";
  };

  postPatch = ''
    sed -i "/^timeout/d" pyproject.toml
  '';

  nativeBuildInputs = [
    hatch-jupyter-builder
    hatch-nodejs-version
    hatchling
    jupyterlab
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "ypy-websocket"
  ];

  propagatedBuildInputs = [
    jupyter-events
    jupyter-server
    jupyter-server-fileid
    jupyter-ydoc
    ypy-websocket
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-jupyter
    pytestCheckHook
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

  meta = with lib; {
    description = "JupyterLab Extension enabling Real-Time Collaboration";
    homepage = "https://github.com/jupyterlab/jupyter_collaboration";
    changelog = "https://github.com/jupyterlab/jupyter_collaboration/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = teams.jupyter.members;
  };
}
