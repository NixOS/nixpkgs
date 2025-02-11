{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  hatch-nodejs-version,
  hatchling,

  # dependencies
  pycrdt,
  pytestCheckHook,

  # tests
  websockets,
  ypy-websocket,
}:

buildPythonPackage rec {
  pname = "jupyter-ydoc";
  version = "3.0.2";
  pyproject = true;

  src = fetchPypi {
    pname = "jupyter_ydoc";
    inherit version;
    hash = "sha256-1fHVvD7JV55YdGlJbNM9bypp4Y50Mp4TDCMUELocMdA=";
  };

  build-system = [
    hatch-nodejs-version
    hatchling
  ];

  dependencies = [ pycrdt ];

  pythonImportsCheck = [ "jupyter_ydoc" ];

  nativeCheckInputs = [
    pytestCheckHook
    websockets
    ypy-websocket
  ];

  # requires a Node.js environment
  doCheck = false;

  meta = {
    changelog = "https://github.com/jupyter-server/jupyter_ydoc/blob/v${version}/CHANGELOG.md";
    description = "Document structures for collaborative editing using Ypy";
    homepage = "https://github.com/jupyter-server/jupyter_ydoc";
    license = lib.licenses.bsd3;
    maintainers = lib.teams.jupyter.members;
  };
}
