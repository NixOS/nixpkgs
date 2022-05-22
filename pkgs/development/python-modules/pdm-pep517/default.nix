{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, git
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pdm-pep517";
  version = "0.12.5";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-z9FeVJhXkYa9wKGntu6p+YPnw6fdGip7CtItBdbcUJk=";
  };

  preCheck = ''
    HOME=$TMPDIR

    git config --global user.name nobody
    git config --global user.email nobody@example.com
  '';

  checkInputs = [
    pytestCheckHook
    git
  ];

  meta = with lib; {
    homepage = "https://github.com/pdm-project/pdm-pep517";
    description = "Yet another PEP 517 backend.";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
