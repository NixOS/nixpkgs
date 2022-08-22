{ lib
, buildPythonPackage
, fetchPypi
, jupyterlab
, jupyter-lsp
}:

buildPythonPackage rec {
  pname = "jupyterlab-lsp";
  version = "3.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-mtbvIsSXK4VIB5cDT8eRRyjrePGFa02rM2Fobk8gyd0=";
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
