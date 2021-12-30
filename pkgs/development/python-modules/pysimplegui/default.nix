{ lib
, buildPythonPackage
, fetchPypi
, tkinter
}:
buildPythonPackage rec {
  pname = "PySimpleGUI";
  version = "4.55.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-nUDAoMK0w9Luk1hU5I1yT1CK5oEj9LrIByYS3Z5wfew=";
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
