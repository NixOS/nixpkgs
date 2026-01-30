{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-nodejs-version,
  hatchling,

  # dependencies
  pycrdt,
  pytestCheckHook,

  # tests
  pycrdt-websocket,
  websockets,
}:

buildPythonPackage rec {
  pname = "jupyter-ydoc";
  version = "3.3.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jupyter-server";
    repo = "jupyter_ydoc";
    tag = "v${version}";
    hash = "sha256-hcIBLhwRLyDdl7LemK8Et10aS2AVPM0wmHAcnmpA9Zg=";
  };

  build-system = [
    hatch-nodejs-version
    hatchling
  ];

  dependencies = [ pycrdt ];

  pythonImportsCheck = [ "jupyter_ydoc" ];

  nativeCheckInputs = [
    pytestCheckHook
    pycrdt-websocket
    websockets
  ];

  # requires a Node.js environment
  doCheck = false;

  meta = {
    changelog = "https://github.com/jupyter-server/jupyter_ydoc/blob/${src.tag}/CHANGELOG.md";
    description = "Document structures for collaborative editing using Yjs/pycrdt";
    homepage = "https://github.com/jupyter-server/jupyter_ydoc";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.jupyter ];
  };
}
