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
  version = "0.22.1";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e0fe2503d08dc00cda781b1ff89eb10c0decb45b5f8983b4970525b8f108dc02";
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
