{ lib
, buildPythonPackage
, dataclasses
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

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-a4OrgFvdtTcQEJaQoiN+mL+DwLOgADPFF8319qj6Rw0=";
  };

  propagatedBuildInputs = [
    jedi
    pygments
    urwid
    urwid-readline
  ] ++ lib.optionals (pythonOlder "3.7") [
    dataclasses
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
