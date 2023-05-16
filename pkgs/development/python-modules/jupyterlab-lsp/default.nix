{ lib
, buildPythonPackage
, fetchPypi
, jupyterlab
, jupyter-lsp
}:

buildPythonPackage rec {
  pname = "jupyterlab-lsp";
<<<<<<< HEAD
  version = "4.2.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OqsByMrAQKjTqev6QIUiOwVLf71iGdPHtWD2qXZsovM=";
=======
  version = "4.0.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1VPRfs+F24h2xJeoJglZQpuCcPDk6Ptf8cWrAW3G5to=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    # No support for Jupyterlab > 4
    # https://github.com/jupyter-lsp/jupyterlab-lsp/pull/949
    broken = lib.versionAtLeast jupyterlab.version "4.0";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
