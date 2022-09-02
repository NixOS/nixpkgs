{ lib
, buildPythonPackage
, fetchPypi
, jupyterlab
, jupyter-lsp
}:

buildPythonPackage rec {
  pname = "jupyterlab-lsp";
  version = "3.10.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-VZrUaS+X9C3WufCzMKuScD8CuORbuvbpz1mJiolyIqA=";
  };

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
    maintainers = with maintainers; [ doronbehar ];
  };
}
