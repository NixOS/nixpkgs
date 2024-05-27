{
  lib,
  buildPythonPackage,
  fetchPypi,
  pyrect,
}:
buildPythonPackage rec {
  pname = "pygetwindow";
  version = "0.0.9";

  src = fetchPypi {
    pname = "PyGetWindow";
    inherit version;
    hash = "sha256-F4lDVefSswXNgy1xdwg4QBfBaYqQziT29/vwJC3Qpog=";
  };

  doCheck = false;
  # This lib officially only works completely on Windows and partially on MacOS but pyautogui requires it
  # pythonImportsCheck = [ "pygetwindow" ];

  propagatedBuildInputs = [ pyrect ];

  meta = with lib; {
    description = "A simple, cross-platform module for obtaining GUI information on applications' windows.";
    homepage = "https://github.com/asweigart/PyGetWindow";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lucasew ];
  };
}
