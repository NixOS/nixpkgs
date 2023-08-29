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
  version = "1.0.1";

  disabled = pythonOlder "3.8";

  format = "pyproject";

  src = fetchPypi {
    pname = "jupyter_collaboration";
    inherit version;
    hash = "sha256-cf7BpF6WSoHQJQW0IXdpCAGTdkX9RNWZ4JovTHvcPho=";
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

  pythonImportsCheck = [ "jupyter_collaboration" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-jupyter
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "-W" "ignore::DeprecationWarning"
  ];

  preCheck = ''
    export HOME=$TEMP
  '';

  meta = {
    changelog = "https://github.com/jupyterlab/jupyter_collaboration/blob/v${version}/CHANGELOG.md";
    description = "JupyterLab Extension enabling Real-Time Collaboration";
    homepage = "https://github.com/jupyterlab/jupyter_collaboration";
    license = lib.licenses.bsd3;
    maintainers = lib.teams.jupyter.members;
  };
}
