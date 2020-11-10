{ lib, buildPythonPackage, fetchPypi, scipy }:

buildPythonPackage rec {
  pname = "iapws";
  version = "1.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "781285acaedff49d72c074aa308aabf7ca17f486cca490e5ed3f35526bbe4153";
  };

  propagatedBuildInputs = [ scipy ];

  meta = with lib; {
    description = "Python implementation of standard from IAPWS";
    homepage = "https://github.com/jjgomera/iapws";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dawidsowa ];
  };
}
