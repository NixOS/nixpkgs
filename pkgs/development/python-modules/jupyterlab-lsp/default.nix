{ lib
, buildPythonPackage
, fetchPypi
, jupyterlab
, jupyter-lsp
}:

buildPythonPackage rec {
  pname = "jupyterlab-lsp";
  version = "4.0.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1VPRfs+F24h2xJeoJglZQpuCcPDk6Ptf8cWrAW3G5to=";
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
    maintainers = with maintainers; [ ];
  };
}
