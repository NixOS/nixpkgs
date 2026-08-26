{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  hatchling,

  # dependencies
  jsonschema,
  jupyter-events,
  jupyter-server,
  jupyter-server-fileid,
  jupyter-ydoc,
  pycrdt,
  pycrdt-websocket,
  jupyter-collaboration,
}:

buildPythonPackage (finalAttrs: {
  pname = "jupyter-server-ydoc";
  version = "3.0.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "jupyter_server_ydoc";
    inherit (finalAttrs) version;
    hash = "sha256-8lJJjnapC+6cC2uEmd11iFyWRuCpKMfmHwH0VsH4XAQ=";
  };

  build-system = [ hatchling ];

  dependencies = [
    jsonschema
    jupyter-events
    jupyter-server
    jupyter-server-fileid
    jupyter-ydoc
    pycrdt
    pycrdt-websocket
  ];

  pythonImportsCheck = [ "jupyter_server_ydoc" ];

  # no tests
  doCheck = false;

  passthru.tests = jupyter-collaboration;

  meta = {
    description = "Jupyter-server extension integrating collaborative shared models";
    homepage = "https://github.com/jupyterlab/jupyter-collaboration/tree/main/projects/jupyter-server-ydoc";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.jupyter ];
  };
})
