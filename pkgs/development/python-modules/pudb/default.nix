{ lib
, buildPythonPackage
, fetchPypi
, jedi
, pygments
, urwid
, urwid-readline
, pytest-mock
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pudb";
  version = "2022.1.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-a4OrgFvdtTcQEJaQoiN+mL+DwLOgADPFF8319qj6Rw0=";
  };

  propagatedBuildInputs = [
    jedi
    pygments
    urwid
    urwid-readline
  ];

  checkInputs = [
    pytest-mock
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  pythonImportsCheck = [
    "pudb"
  ];

  meta = with lib; {
    description = "A full-screen, console-based Python debugger";
    homepage = "https://github.com/inducer/pudb";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
