{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  ipykernel,
  ipywidgets,
  jupyter-console,
  jupyterlab,
  nbconvert,
  notebook,
}:

buildPythonPackage rec {
  pname = "jupyter";
  version = "1.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1VRnvOq96knX42JK9+M9WcN//1PtOjUOGslXvtcx3no=";
  };

  build-system = [ setuptools ];

  dependencies = [
    ipykernel
    ipywidgets
    jupyter-console
    jupyterlab
    nbconvert
    notebook
  ];

  # Meta-package, no tests
  doCheck = false;

  dontUsePythonImportsCheck = true;

  meta = with lib; {
    description = "Installs all the Jupyter components in one go";
    homepage = "https://jupyter.org/";
    license = licenses.bsd3;
    priority = 100; # This is a metapackage which is unimportant
  };
}
