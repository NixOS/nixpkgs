{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, jupyter-server
}:

buildPythonPackage rec {
  pname = "jupyter-lsp";
  version = "1.5.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dRq9NUE76ZpDMfNZewk0Gtx1VYntMgkawvaG2z1hJn4=";
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
    maintainers = with maintainers; [ doronbehar ];
  };
}

