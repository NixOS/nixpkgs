{ lib
, buildPythonPackage
, fetchPypi
, tkinter
}:
buildPythonPackage rec {
  pname = "PySimpleGUI";
  version = "4.56.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1a13a19282f92626cc6a823cbe9f4aa08aa558870f03441a1c4e8b6cef27c9d5";
  };

  pythonImportsCheck = [ "PySimpleGUI" ];

  propagatedBuildInputs = [
    tkinter
  ];

  meta = with lib; {
    description = "Python GUIs for Humans.";
    homepage = "https://github.com/PySimpleGUI/PySimpleGUI";
    license = licenses.gpl3;
    maintainers = with maintainers; [ lucasew ];
  };
}
