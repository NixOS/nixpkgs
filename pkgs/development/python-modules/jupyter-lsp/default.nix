{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  jupyter-server,
}:

buildPythonPackage rec {
  pname = "jupyter-lsp";
  version = "2.2.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eTFHoFrURvgJ/VPvHNGan1JW/Qota3zpQ6mCy09UUAE=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ jupyter-server ];
  # tests require network
  doCheck = false;
  pythonImportsCheck = [ "jupyter_lsp" ];

  meta = with lib; {
    description = "Multi-Language Server WebSocket proxy for your Jupyter notebook or lab server";
    homepage = "https://jupyterlab-lsp.readthedocs.io/en/latest/";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
