{ lib, buildPythonPackage, fetchPypi
, jupyter-packaging
, jupyter_server
, pytest-tornasync
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jupyter-server-mathjax";
  version = "0.2.3";

  src = fetchPypi {
    inherit version;
    pname = "jupyter_server_mathjax";
    sha256 = "564e8d1272019c6771208f577b5f9f2b3afb02b9e2bff3b34c042cef8ed84451";
  };

  nativeBuildInputs = [
    jupyter-packaging
  ];

  propagatedBuildInputs = [
    jupyter_server
  ];

  checkInputs = [
    pytest-tornasync
    pytestCheckHook
  ];

  pythonImportsCheck = [ "jupyter_server_mathjax" ];

  meta = with lib; {
    description = "MathJax resources as a Jupyter Server Extension";
    homepage = "http://jupyter.org";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jonringer ];
  };
}
