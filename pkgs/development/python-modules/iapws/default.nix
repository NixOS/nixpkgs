{ lib, buildPythonPackage, fetchPypi, scipy }:

buildPythonPackage rec {
  pname = "iapws";
  version = "1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3d7a7a17343157dacd3f654b7f82d1974492209756c4de99332d4f6b375227e6";
  };

  propagatedBuildInputs = [ scipy ];

  meta = with lib; {
    description = "Python implementation of standard from IAPWS";
    homepage = "https://github.com/jjgomera/iapws";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dawidsowa ];
  };
}
