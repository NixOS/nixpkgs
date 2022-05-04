{ lib, buildPythonPackage, fetchPypi
, jupyter-packaging
, jupyter_server
, pytest-tornasync
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jupyter-server-mathjax";
  version = "0.2.5";

  src = fetchPypi {
    inherit version;
    pname = "jupyter_server_mathjax";
    sha256 = "sha256-ZNlsjm3+btunN5ArLcOi3AWPF1FndsJfTTDKJGF+57M=";
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
    homepage = "https://jupyter.org";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jonringer ];
  };
}
