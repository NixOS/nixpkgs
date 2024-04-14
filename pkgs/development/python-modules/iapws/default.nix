{ lib, buildPythonPackage, fetchPypi, scipy }:

buildPythonPackage rec {
  pname = "iapws";
  version = "1.5.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QVxbf9EF9YwAVPewAqhc1WZD6jVr/rFXQUw/jJ7kkDU=";
  };

  propagatedBuildInputs = [ scipy ];

  meta = with lib; {
    description = "Python implementation of standard from IAPWS";
    homepage = "https://github.com/jjgomera/iapws";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dawidsowa ];
  };
}
