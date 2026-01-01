{
  lib,
  buildPythonPackage,
  fetchPypi,
  pyrect,
}:
buildPythonPackage rec {
  pname = "pygetwindow";
  version = "0.0.9";
  format = "setuptools";

  src = fetchPypi {
    pname = "PyGetWindow";
    inherit version;
    hash = "sha256-F4lDVefSswXNgy1xdwg4QBfBaYqQziT29/vwJC3Qpog=";
  };

  doCheck = false;
  # This lib officially only works completely on Windows and partially on MacOS but pyautogui requires it
  # pythonImportsCheck = [ "pygetwindow" ];

  propagatedBuildInputs = [ pyrect ];

<<<<<<< HEAD
  meta = {
    description = "Simple, cross-platform module for obtaining GUI information on applications' windows";
    homepage = "https://github.com/asweigart/PyGetWindow";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ lucasew ];
=======
  meta = with lib; {
    description = "Simple, cross-platform module for obtaining GUI information on applications' windows";
    homepage = "https://github.com/asweigart/PyGetWindow";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lucasew ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
