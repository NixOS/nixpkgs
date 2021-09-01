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
  version = "0.32.2";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4c5743a05150ed7736e028aac15787a66735f160e9ae198dacc5a4bd1a727ce2";
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
