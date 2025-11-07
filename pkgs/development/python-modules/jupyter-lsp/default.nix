{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  jupyter-server,
}:

buildPythonPackage rec {
  pname = "jupyter-lsp";
  version = "2.2.6";
  pyproject = true;

  src = fetchPypi {
    pname = "jupyter_lsp";
    inherit version;
    hash = "sha256-BWa9m7BP2eZ3SpN+0BUitVW6eL43vr73h8irIt5MA2E=";
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
