{ stdenv
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
  version = "0.23.3";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "20a4954d8d1b1eb6f9111cd15d6a598bd7ff72b08797cf5e86c5a55827c85a1d";
  };

  propagatedBuildInputs = [ notebook nbdime git ];

  # all Tests on darwin fail or are skipped due to sandbox
  doCheck = !stdenv.isDarwin;

  checkInputs = [ pytest ];

  checkPhase = ''
    pytest jupyterlab_git/ --ignore=jupyterlab_git/tests/test_handlers.py
  '';

  pythonImportsCheck = [ "jupyterlab_git" ];

  meta = with stdenv.lib; {
    description = "Jupyter lab extension for version control with Git.";
    license = with licenses; [ bsd3 ];
    homepage = "https://github.com/jupyterlab/jupyterlab-git";
    maintainers = with maintainers; [ chiroptical ];
  };
}
