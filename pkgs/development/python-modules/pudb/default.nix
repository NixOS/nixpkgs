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
  version = "2023.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Fd88YDq6h6kYpmbvjhv2P3ZCOMw1ids8W3pfGwHqLwM=";
  };

  propagatedBuildInputs = [
    jedi
    pygments
    urwid
    urwid-readline
  ];

  nativeCheckInputs = [
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
    changelog = "https://github.com/inducer/pudb/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
