{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  jupyter-server,
}:

buildPythonPackage rec {
  pname = "jupyter-lsp";
  version = "2.3.1";
  pyproject = true;

  src = fetchPypi {
    pname = "jupyter_lsp";
    inherit version;
    hash = "sha256-/fikqn2FgTl21uKeleaiyPdScB+SbycVMFJJo4KYBaY=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ jupyter-server ];
  # tests require network
  doCheck = false;
  pythonImportsCheck = [ "jupyter_lsp" ];

  meta = {
    description = "Multi-Language Server WebSocket proxy for your Jupyter notebook or lab server";
    homepage = "https://jupyterlab-lsp.readthedocs.io/en/latest/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}
