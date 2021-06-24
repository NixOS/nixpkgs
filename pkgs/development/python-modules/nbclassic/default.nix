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
  version = "0.2.6";
  disabled = pythonOlder "3.5";

  # tests only on github
  src = fetchFromGitHub {
    owner = "jupyterlab";
    repo = pname;
    rev = version;
    sha256 = "sha256-stp0LZJAOCrnObvJIPEVt8mMb8yL29nlHECypbTg3ec=";
  };

  propagatedBuildInputs = [ jupyter_server notebook ];

  checkInputs = [
    pytestCheckHook
    pytest-tornasync
  ];

  meta = with lib; {
    description = "Jupyter lab environment notebook server extension.";
    license = with licenses; [ bsd3 ];
    homepage = "https://github.com/jupyterlab/nbclassic";
    maintainers = [ maintainers.elohmeier ];
  };
}
