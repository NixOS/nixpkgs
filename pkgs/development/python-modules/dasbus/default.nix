{ lib, buildPythonPackage, fetchPypi, pygobject3, dbus }:

buildPythonPackage rec {
  pname = "dasbus";
  version = "1.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qIUNhBrf6O5fe7n4LPRJq5tJUNwGM4lwcXGODQA2tvY=";
  };

  propagatedBuildInputs = [ pygobject3 ];
  checkInputs = [ dbus ];

  meta = with lib; {
    homepage = "https://github.com/rhinstaller/dasbus";
    description = "DBus library in Python3";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ fortuneteller2k ];
  };
}
