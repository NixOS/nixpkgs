{ lib, buildPythonPackage, fetchPypi, scipy }:

buildPythonPackage rec {
  pname = "iapws";
  version = "1.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d65c813bb6b100a8d1ed79e00148832a0321b3063e9632a990344890acb02493";
  };

  propagatedBuildInputs = [ scipy ];

  meta = with lib; {
    description = "Python implementation of standard from IAPWS";
    homepage = "https://github.com/jjgomera/iapws";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dawidsowa ];
  };
}
