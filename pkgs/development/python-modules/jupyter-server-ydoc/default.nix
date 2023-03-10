{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, hatchling
, jupyter-server-fileid
, jupyter-ydoc
, ypy-websocket
, pytest-jupyter
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jupyter-server-ydoc";
  version = "0.8.0";

  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "jupyterlab";
    repo = "jupyter_collaboration";
    rev = "refs/tags/v${version}";
    hash = "sha256-KLb7kU5jsj6ihGO6HU3Y7uF+0PcwKoQlqQAhtO0oaJw=";
  };

  postPatch = ''
    sed -i "/^timeout/d" pyproject.toml
  '';

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    jupyter-server-fileid
    jupyter-ydoc
    ypy-websocket
  ];

  pythonImportsCheck = [ "jupyter_server_ydoc" ];

  nativeCheckInputs = [
    pytest-jupyter
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$TEMP
  '';

  meta = {
    changelog = "https://github.com/jupyterlab/jupyter_collaboration/blob/${src.rev}/CHANGELOG.md";
    description = "A Jupyter Server Extension Providing Y Documents";
    homepage = "https://github.com/jupyterlab/jupyter_collaboration";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
