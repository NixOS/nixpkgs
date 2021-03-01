{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "phonenumbers";
  version = "8.12.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "96d02120a3481e22d8a8eb5e4595ceec1930855749f6e4a06ef931881f59f562";
  };

  meta = with lib; {
    description = "Python version of Google's common library for parsing, formatting, storing and validating international phone numbers";
    homepage    = "https://github.com/daviddrysdale/python-phonenumbers";
    license     = licenses.asl20;
    maintainers = with maintainers; [ fadenb ];
  };
}
