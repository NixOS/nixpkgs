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
  version = "5.1.1";
  pyproject = true;

  src = fetchPypi {
    pname = "jupyterlab_lsp";
    inherit version;
    hash = "sha256-cjPKc+oPLahZjqM9hMJDY1Rm0a9w3c6M2DNu+V3KCL8=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    jupyterlab
    jupyter-lsp
  ];
  # No tests
  doCheck = false;
  pythonImportsCheck = [ "jupyterlab_lsp" ];

  meta = with lib; {
    description = "Language Server Protocol integration for Jupyter(Lab)";
    homepage = "https://github.com/jupyter-lsp/jupyterlab-lsp";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
