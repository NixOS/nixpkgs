{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, jupyter-server
}:

buildPythonPackage rec {
  pname = "jupyter-lsp";
<<<<<<< HEAD
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jrvLUzrbQeXWNeuP6ClWsKr78P1EO2xL+pBu3uuGNaE=";
=======
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-89n1mdSOCTpLq/vawZTDAzLmJIzkoD1z+nEviMd55Rk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    jupyter-server
  ];
  # tests require network
  doCheck = false;
  pythonImportsCheck = [ "jupyter_lsp" ];

  meta = with lib; {
    description = "Multi-Language Server WebSocket proxy for your Jupyter notebook or lab server";
    homepage = "https://jupyterlab-lsp.readthedocs.io/en/latest/";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ ];
  };
}

