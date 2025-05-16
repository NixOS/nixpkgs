{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  jsonschema,
  jupyter-events,
  jupyter-server,
  jupyter-server-fileid,
  jupyter-ydoc,
  pycrdt,
  pycrdt-websocket,
  jupyter-collaboration,
}:

buildPythonPackage rec {
  pname = "jupyter-server-ydoc";
  version = "2.0.2";
  pyproject = true;

  src = fetchPypi {
    pname = "jupyter_server_ydoc";
    inherit version;
    hash = "sha256-Iu5y57yeLZ/emIIJLRdqyMpxAfsHj2/vTLcqgSlRCSg=";
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

  passthru.tests = jupyter-collaboration.tests;

  meta = {
    description = "Jupyter-server extension integrating collaborative shared models";
    homepage = "https://github.com/jupyterlab/jupyter-collaboration/tree/main/projects/jupyter-server-ydoc";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.jupyter ];
  };
}
