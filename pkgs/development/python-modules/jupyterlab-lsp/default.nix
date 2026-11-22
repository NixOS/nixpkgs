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
  version = "5.3.0";
  pyproject = true;

  src = fetchPypi {
    pname = "jupyterlab_lsp";
    inherit version;
    hash = "sha256-vfAU/rwOwpf/aQh+lXVJ1yTrDCnfPyTU9MQHWKca/D8=";
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
