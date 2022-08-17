{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, notebook
, pythonOlder
, jupyter_server
, pytestCheckHook
, pytest-tornasync
}:

buildPythonPackage rec {
  pname = "nbclassic";
  version = "0.4.3";
  disabled = pythonOlder "3.6";

  # tests only on github
  src = fetchFromGitHub {
    owner = "jupyterlab";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-5sof5EOqzK7kNHSXp7eJl3ZagZRWF74e08ahqJId2Z8=";
  };

  propagatedBuildInputs = [ jupyter_server notebook ];

  preCheck = ''
    cd nbclassic
    mv conftest.py tests
    cd tests

    export PYTHONPATH=$out/${python.sitePackages}:$PYTHONPATH
  '';
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
