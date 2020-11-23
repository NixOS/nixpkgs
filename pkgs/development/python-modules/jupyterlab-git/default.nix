{ lib
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
  version = "0.22.3";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "434ff9edd1190809e02e0cbf50090c28de48a51e151a1f904ac66e902244398d";
  };

  propagatedBuildInputs = [ notebook nbdime git ];

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
