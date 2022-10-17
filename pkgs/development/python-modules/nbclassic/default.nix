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
  version = "0.4.5";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-BXBMbN2DAb9S5A7Z+uOegNa8XS1EfcZ4McFFtN2Sh3k=";
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
