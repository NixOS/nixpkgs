{ lib
, buildPythonPackage
, fetchPypi
, tkinter
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pysimplegui";
  version = "4.57.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "PySimpleGUI";
    inherit version;
    sha256 = "sha256-+Dcrv+esnthI74AFLK47sS2qI4sPvihuQlL54Zo32RM=";
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
    maintainers = with maintainers; [ lucasew ];
  };
}
