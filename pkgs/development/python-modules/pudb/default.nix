{ lib
, buildPythonPackage
, isPy3k
, fetchPypi
, jedi
, pygments
, urwid
, pytest-mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pudb";
  version = "2021.1";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "309ee82b45a0ffca0bc4c7f521fd3e357589c764f339bdf9dcabb7ad40692d6e";
  };

  propagatedBuildInputs = [
    jedi
    pygments
    urwid
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  checkInputs = [
    pytest-mock
    pytestCheckHook
  ];

  meta = with lib; {
    description = "A full-screen, console-based Python debugger";
    homepage = "https://github.com/inducer/pudb";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
