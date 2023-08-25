{ lib
, buildPythonPackage
, fetchPypi
, jupyterlab
, jupyter-lsp
}:

buildPythonPackage rec {
  pname = "jupyterlab-lsp";
  version = "4.2.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OqsByMrAQKjTqev6QIUiOwVLf71iGdPHtWD2qXZsovM=";
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
    # No support for Jupyterlab > 4
    # https://github.com/jupyter-lsp/jupyterlab-lsp/pull/949
    broken = lib.versionAtLeast jupyterlab.version "4.0";
  };
}
