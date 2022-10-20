{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "patiencediff";
  version = "0.2.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-wdaNB6VzqeLEt5HBMIki08j08aRuc11l4wg8J01e5Fk=";
  };

  meta = with lib; {
    description = "C implementation of patiencediff algorithm for Python";
    homepage = "https://github.com/breezy-team/patiencediff";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.wildsebastian ];
  };
}
