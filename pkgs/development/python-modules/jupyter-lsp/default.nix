{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, jupyter-server
}:

buildPythonPackage rec {
  pname = "jupyter-lsp";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-89n1mdSOCTpLq/vawZTDAzLmJIzkoD1z+nEviMd55Rk=";
  };

  propagatedBuildInputs = [
    jupyter-server
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

