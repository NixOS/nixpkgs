{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "phonenumbers";
  version = "8.12.25";

  src = fetchPypi {
    inherit pname version;
    sha256 = "de4db4e2582f989a9cbae54364a647b24a72a7b0126be50d8356cf02217dc6c9";
  };

  meta = with lib; {
    description = "Python version of Google's common library for parsing, formatting, storing and validating international phone numbers";
    homepage    = "https://github.com/daviddrysdale/python-phonenumbers";
    license     = licenses.asl20;
    maintainers = with maintainers; [ fadenb ];
  };
}
