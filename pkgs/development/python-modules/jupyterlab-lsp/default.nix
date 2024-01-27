{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, jupyterlab
, jupyter-lsp
}:

buildPythonPackage rec {
  pname = "jupyterlab-lsp";
  version = "5.0.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JmiGhOkHUPjvikFimgpAUOc26IFVWqFBP7Xah54GNfE=";
  };

  nativeBuildInputs = [
    setuptools
  ];

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
    maintainers = with maintainers; [ ];
  };
}
