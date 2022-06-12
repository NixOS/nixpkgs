{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, jupyter_server
}:

buildPythonPackage rec {
  pname = "jupyter-lsp";
  version = "1.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-dRq9NUE76ZpDMfNZewk0Gtx1VYntMgkawvaG2z1hJn4=";
  };

  propagatedBuildInputs = [
    jupyter_server
  ];
  # tests require network
  doCheck = false;
  pythonImportsCheck = [ "jupyter_lsp" ];

  meta = with lib; {
    description = "Multi-Language Server WebSocket proxy for your Jupyter notebook or lab server";
    homepage = "https://pypi.org/project/jupyter-lsp";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ doronbehar ];
  };
}

