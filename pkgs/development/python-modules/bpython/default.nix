{ lib
, buildPythonPackage
, fetchPypi
, curtsies
, cwcwidth
, greenlet
, jedi
, pygments
, pytestCheckHook
, pythonOlder
, pyperclip
, pyxdg
, requests
, substituteAll
, typing-extensions
, urwid
, watchdog
}:

buildPythonPackage rec {
  pname = "bpython";
  version = "0.23";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nwB4q8iHxIrwiGkeL2R5fWyplKwPS8A8ONBvZX18BSo=";
  };

  propagatedBuildInputs = [
    curtsies
    cwcwidth
    greenlet
    jedi
    pygments
    pyperclip
    pyxdg
    requests
    typing-extensions
    urwid
    watchdog
  ];

  postInstall = ''
    substituteInPlace "$out/share/applications/org.bpython-interpreter.bpython.desktop" \
      --replace "Exec=/usr/bin/bpython" "Exec=$out/bin/bpython"
  '';

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "bpython"
  ];

  disabledTests = [
    # Check for syntax error ends with an AssertionError
    "test_syntaxerror"
  ];

  meta = with lib; {
    description = "A fancy curses interface to the Python interactive interpreter";
    homepage = "https://bpython-interpreter.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ flokli dotlambda ];
  };
}
