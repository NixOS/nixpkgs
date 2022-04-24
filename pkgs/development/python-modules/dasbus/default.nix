{ lib, buildPythonPackage, fetchPypi, pygobject3, dbus }:

buildPythonPackage rec {
  pname = "dasbus";
  version = "1.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FJrY/Iw9KYMhq1AVm1R6soNImaieR+IcbULyyS5W6U0=";
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
