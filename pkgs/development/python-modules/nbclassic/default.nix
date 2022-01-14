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
  version = "0.3.5";
  disabled = pythonOlder "3.6";

  # tests only on github
  src = fetchFromGitHub {
    owner = "jupyterlab";
    repo = pname;
    rev = version;
    sha256 = "1d0x7nwsaw5qjw4iaylc2sxlpiq3hlg9sy3i2nh7sn3wckwl76lc";
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
