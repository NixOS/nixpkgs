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
  version = "0.4.6";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-PBjTQ7KS+TjvyTIFdh5nTyDsoG6tJeDu3Bf3riUr9W0=";
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
