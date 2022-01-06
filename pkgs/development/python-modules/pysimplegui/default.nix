{ lib
, buildPythonPackage
, fetchPypi
, tkinter
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pysimplegui";
  version = "4.56.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "PySimpleGUI";
    inherit version;
    sha256 = "1a13a19282f92626cc6a823cbe9f4aa08aa558870f03441a1c4e8b6cef27c9d5";
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
