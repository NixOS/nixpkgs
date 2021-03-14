{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "phonenumbers";
  version = "8.12.18";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0aa0f5e1382d292a7ff2f8bc08673126521461c7f908e0220756449a734d8fef";
  };

  meta = with lib; {
    description = "Python version of Google's common library for parsing, formatting, storing and validating international phone numbers";
    homepage    = "https://github.com/daviddrysdale/python-phonenumbers";
    license     = licenses.asl20;
    maintainers = with maintainers; [ fadenb ];
  };
}
