{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "phonenumbers";
  version = "8.12.20";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ee5a8508c4a414262abad92ec33f050347f681973ed0fb36e98b52bfe159f6b8";
  };

  meta = with lib; {
    description = "Python version of Google's common library for parsing, formatting, storing and validating international phone numbers";
    homepage    = "https://github.com/daviddrysdale/python-phonenumbers";
    license     = licenses.asl20;
    maintainers = with maintainers; [ fadenb ];
  };
}
