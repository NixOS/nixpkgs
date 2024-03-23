{ lib
, buildPythonPackage
, fetchPypi
, tkinter
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pysimplegui";
  version = "5.0.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "PySimpleGUI";
    inherit version;
    hash = "sha256-bnjPVGMVfma/tn8oCg6FLMI1W+9rtHMKNdarbNg61GM=";
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
    license = licenses.unfree;
    maintainers = with maintainers; [ lucasew ];
    broken = true; # update to v5 broke the package, it now needs rsa and is trying to access an X11 socket?
  };
}
