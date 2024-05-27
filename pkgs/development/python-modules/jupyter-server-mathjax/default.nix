{
  lib,
  buildPythonPackage,
  fetchPypi,
  jupyter-packaging,
  setuptools,
  jupyter-server,
  pytest-jupyter,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "jupyter-server-mathjax";
  version = "0.2.6";
  format = "pyproject";

  src = fetchPypi {
    inherit version;
    pname = "jupyter_server_mathjax";
    hash = "sha256-ux5rbcBobB/jhqIrWIYWPbVIiTqZwoEMNjmenEyiOUM=";
  };

  nativeBuildInputs = [
    jupyter-packaging
    setuptools
  ];

  propagatedBuildInputs = [ jupyter-server ];

  nativeCheckInputs = [
    pytest-jupyter
    pytestCheckHook
  ];

  pythonImportsCheck = [ "jupyter_server_mathjax" ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "MathJax resources as a Jupyter Server Extension";
    homepage = "https://github.com/jupyter-server/jupyter_server_mathjax";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jonringer ];
  };
}
