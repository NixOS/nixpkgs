{ lib
, buildPythonPackage
, fetchPypi
, tkinter
, pythonOlder
, stdenv
}:

buildPythonPackage rec {
  pname = "pysimplegui";
  version = "4.60.4";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "PySimpleGUI";
    inherit version;
    hash = "sha256-+IyCwwGlGuo1vmBdwGC8zrDctmguFigFRIhHAatLI7o=";
  };

  propagatedBuildInputs = [
    tkinter
  ];

  pythonImportsCheck = [
    "PySimpleGUI"
  ];

  meta = with lib; {
    description = "Python GUIs for Humans";
    homepage = "https://github.com/PySimpleGUI/PySimpleGUI";
    license = licenses.lgpl3Plus;
    broken = stdenv.isDarwin; # build is broken on darwin
    maintainers = with maintainers; [ lucasew ];
  };
}
