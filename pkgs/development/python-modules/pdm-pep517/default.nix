{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, git
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pdm-pep517";
  version = "1.0.4";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-OS+MK0fG7CBVDLjhniS529Jzc0E/BntW7Ndfl2f5MBU=";
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
