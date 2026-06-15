{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-nodejs-version,
  hatchling,

  # dependencies
  anyio,
  pycrdt,

  # tests
  pycrdt-websocket,
  pytestCheckHook,
  websockets,
}:

buildPythonPackage (finalAttrs: {
  pname = "jupyter-ydoc";
  version = "4.0.0b1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jupyter-server";
    repo = "jupyter_ydoc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yr6Nyl3Vyekmf8+xSWGw5Vs6M3YDJIdImttQgoQld2Y=";
  };

  build-system = [
    hatch-nodejs-version
    hatchling
  ];

  pythonRelaxDeps = [
    "pycrdt"
  ];
  dependencies = [
    anyio
    pycrdt
  ];

  pythonImportsCheck = [ "jupyter_ydoc" ];

  nativeCheckInputs = [
    pytestCheckHook
    pycrdt-websocket
    websockets
  ];

  # requires a Node.js environment
  doCheck = false;

  meta = {
    changelog = "https://github.com/jupyter-server/jupyter_ydoc/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Document structures for collaborative editing using Yjs/pycrdt";
    homepage = "https://github.com/jupyter-server/jupyter_ydoc";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.jupyter ];
  };
})
