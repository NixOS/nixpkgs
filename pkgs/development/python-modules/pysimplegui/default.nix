{ lib
, buildPythonPackage
, fetchPypi
, tkinter
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pysimplegui";
  version = "4.60.5";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "PySimpleGUI";
    inherit version;
    hash = "sha256-MQFNHMXu8Tc9fpNWT/JgRmJkXMd0qTmx8BqiU+f514s=";
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
