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
  version = "2021.2.2";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "82a524ab4b89d2c701b089071ccc6afa9c8a838504e3d68eb33faa8a8abbe4cb";
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
