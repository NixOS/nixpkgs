{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  mouseinfo,
  pygetwindow,
  pymsgbox,
  pyperclip,
  pyscreeze,
  pytweening,
  tkinter,
  python-xlib,
  xvfb-run,
  scrot,
}:
buildPythonPackage (finalAttrs: {
  pname = "pyautogui";
  version = "0.9.53";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "asweigart";
    repo = "pyautogui";
    rev = "5e4acb870f2e7ce0ea1927cc5188bc2f5ab7bbbc";
    hash = "sha256-R9tcTqxUaqw63FLOGFRaO/Oz6kD7V6MPHdQ8A29NdXw=";
  };

  patches = [
    # https://github.com/asweigart/pyautogui/issues/598
    ./fix-locateOnWindow-and-xlib.patch
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    mouseinfo
    pygetwindow
    pymsgbox
    python-xlib
    tkinter
    pyperclip
    pyscreeze
    pytweening
  ];

  nativeCheckInputs = [
    xvfb-run
    scrot
  ];

  checkPhase = ''
    xvfb-run python -c 'import pyautogui'
    # The tests depend on some specific things that xvfb cant provide, like keyboard and mouse
    # xvfb-run python -m unittest tests.test_pyautogui
  '';

  meta = {
    description = "PyAutoGUI lets Python control the mouse and keyboard, and other GUI automation tasks";
    homepage = "https://github.com/asweigart/pyautogui";
    changelog = "https://github.com/asweigart/pyautogui/blob/${finalAttrs.src.rev}/CHANGES.txt";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    hasNoMaintainersButDependents = true;
  };
})
