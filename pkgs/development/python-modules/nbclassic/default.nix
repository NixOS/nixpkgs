{ lib
, buildPythonPackage
, fetchFromGitHub
, notebook
, pythonOlder
, jupyter_server
, pytestCheckHook
, pytest-tornasync
}:

buildPythonPackage rec {
  pname = "nbclassic";
  version = "0.3.1";
  disabled = pythonOlder "3.6";

  # tests only on github
  src = fetchFromGitHub {
    owner = "jupyterlab";
    repo = pname;
    rev = version;
    sha256 = "sha256-gx086w/qYB02UFEDly+0mUsV5BvAVAuhqih4wev2p/w=";
  };

  propagatedBuildInputs = [ jupyter_server notebook ];

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
