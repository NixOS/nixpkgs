{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, jupyter-server
}:

buildPythonPackage rec {
  pname = "jupyter-lsp";
  version = "2.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jrvLUzrbQeXWNeuP6ClWsKr78P1EO2xL+pBu3uuGNaE=";
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

