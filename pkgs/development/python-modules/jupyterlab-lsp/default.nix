{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  jupyterlab,
  jupyter-lsp,
}:

buildPythonPackage rec {
  pname = "jupyterlab-lsp";
  version = "5.2.0";
  pyproject = true;

  src = fetchPypi {
    pname = "jupyterlab_lsp";
    inherit version;
    hash = "sha256-Y2hIhbNcHcnYPlS0sGOAyTda19dRopdWSbNXMIyNMLk=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    jupyterlab
    jupyter-lsp
  ];
  # No tests
  doCheck = false;
  pythonImportsCheck = [ "jupyterlab_lsp" ];

  meta = {
    description = "Language Server Protocol integration for Jupyter(Lab)";
    homepage = "https://github.com/jupyter-lsp/jupyterlab-lsp";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}
