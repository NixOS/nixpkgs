{ lib
, buildPythonPackage
, fetchPypi
, notebook
, notebook-shim
, pythonOlder
, jupyter_server
, pytestCheckHook
, pytest-tornasync
}:

buildPythonPackage rec {
  pname = "nbclassic";
  version = "0.4.3";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-8DERss66ppuINwp7I7GbKzfJu3F2fxgozf16BH6ujt0=";
  };

  propagatedBuildInputs = [ jupyter_server notebook notebook-shim ];

  checkInputs = [
    pytestCheckHook
    pytest-tornasync
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Jupyter lab environment notebook server extension.";
    license = with licenses; [ bsd3 ];
    homepage = "https://github.com/jupyterlab/nbclassic";
    maintainers = [ maintainers.elohmeier ];
  };
}
