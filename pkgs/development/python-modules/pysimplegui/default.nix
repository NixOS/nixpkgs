{
  lib,
  buildPythonPackage,
  fetchPypi,
  tkinter,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pysimplegui";
  version = "5.0.5";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "PySimpleGUI";
    inherit version;
    hash = "sha256-4B2LgWmdXAU9ACSR0F26Q9+eP3izRI+p6QS/o9m6Hfk=";
  };

  propagatedBuildInputs = [ tkinter ];

  pythonImportsCheck = [ "PySimpleGUI" ];

  meta = with lib; {
    description = "Python GUIs for Humans";
    homepage = "https://github.com/PySimpleGUI/PySimpleGUI";
    license = licenses.unfree;
    maintainers = with maintainers; [ lucasew ];
    broken = true; # update to v5 broke the package, it now needs rsa and is trying to access an X11 socket?
  };
}
