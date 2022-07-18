{ lib
, buildPythonPackage
, fetchFromGitHub
, mouseinfo
, pygetwindow
, pymsgbox
, pyperclip
, pyscreeze
, pytweening
, tkinter
, xlib
, xvfb-run
, scrot
}:
buildPythonPackage rec {
  pname = "pyautogui";
  version = "0.9.53";

  src = fetchFromGitHub {
    owner = "asweigart";
    repo = "pyautogui";
    rev = "5e4acb870f2e7ce0ea1927cc5188bc2f5ab7bbbc";
    sha256 = "sha256-R9tcTqxUaqw63FLOGFRaO/Oz6kD7V6MPHdQ8A29NdXw=";
  };

  checkInputs = [ xvfb-run scrot ];
  checkPhase = ''
    xvfb-run python -c 'import pyautogui'
    # The tests depend on some specific things that xvfb cant provide, like keyboard and mouse
    # xvfb-run python -m unittest tests.test_pyautogui
  '';

  patches = [
    # https://github.com/asweigart/pyautogui/issues/598
    ./fix-locateOnWindow-and-xlib.patch
  ];

  propagatedBuildInputs = [
    mouseinfo
    pygetwindow
    pymsgbox
    xlib
    tkinter
    pyperclip
    pyscreeze
    pytweening
  ];

  meta = with lib; {
    description = "PyAutoGUI lets Python control the mouse and keyboard, and other GUI automation tasks.";
    homepage = "https://github.com/asweigart/pyautogui";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lucasew ];
  };
}
