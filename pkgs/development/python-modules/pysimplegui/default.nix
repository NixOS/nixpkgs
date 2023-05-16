{ lib
, buildPythonPackage
, fetchPypi
, tkinter
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pysimplegui";
<<<<<<< HEAD
  version = "4.60.5";
=======
  version = "4.60.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "PySimpleGUI";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-MQFNHMXu8Tc9fpNWT/JgRmJkXMd0qTmx8BqiU+f514s=";
=======
    hash = "sha256-+IyCwwGlGuo1vmBdwGC8zrDctmguFigFRIhHAatLI7o=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
