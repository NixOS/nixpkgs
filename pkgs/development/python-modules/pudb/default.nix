{ lib
, buildPythonPackage
, dataclasses
, isPy3k
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
  version = "2022.1";
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "e827a4b489dcad561189535db6677becbf32164b2b44df00786eb2d5e00c587e";
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
