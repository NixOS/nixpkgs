{ lib, stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, notebook
, nbdime
, git
, pytest
}:

buildPythonPackage rec {
  pname = "jupyterlab_git";
  version = "0.33.0";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2370f3cefa5fef4d37dc211035cdccfe7cc4ef170df76413765a1933c5217465";
  };

  propagatedBuildInputs = [ notebook nbdime git ];

  # all Tests on darwin fail or are skipped due to sandbox
  doCheck = !stdenv.isDarwin;

  checkInputs = [ pytest ];

  checkPhase = ''
    pytest jupyterlab_git/ --ignore=jupyterlab_git/tests/test_handlers.py
  '';

  pythonImportsCheck = [ "jupyterlab_git" ];

  meta = with lib; {
    description = "Jupyter lab extension for version control with Git.";
    license = with licenses; [ bsd3 ];
    homepage = "https://github.com/jupyterlab/jupyterlab-git";
    maintainers = with maintainers; [ chiroptical ];
  };
}
