{ lib
, buildPythonPackage
, fetchPypi
, jupyter-packaging
, jupyter-server
, pytest-tornasync
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jupyter-server-mathjax";
  version = "0.2.6";

  src = fetchPypi {
    inherit version;
    pname = "jupyter_server_mathjax";
    sha256 = "sha256-ux5rbcBobB/jhqIrWIYWPbVIiTqZwoEMNjmenEyiOUM=";
  };

  nativeBuildInputs = [
    jupyter-packaging
  ];

  propagatedBuildInputs = [
    jupyter-server
  ];

  checkInputs = [
    pytest-tornasync
    pytestCheckHook
  ];

  pythonImportsCheck = [ "jupyter_server_mathjax" ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "MathJax resources as a Jupyter Server Extension";
    homepage = "https://jupyter.org";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jonringer ];
  };
}
