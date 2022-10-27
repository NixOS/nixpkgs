{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, git
, pytestCheckHook
, setuptools
}:

buildPythonPackage rec {
  pname = "pdm-pep517";
  version = "1.0.5";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-dOzpaUxP9fkD+6AA7EPwdRQ4csQSSNrM7PdGT5jOaAw=";
  };

  preCheck = ''
    HOME=$TMPDIR

    git config --global user.name nobody
    git config --global user.email nobody@example.com
  '';

  checkInputs = [
    setuptools
    pytestCheckHook
    git
    setuptools
  ];

  meta = with lib; {
    homepage = "https://github.com/pdm-project/pdm-pep517";
    description = "Yet another PEP 517 backend.";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
