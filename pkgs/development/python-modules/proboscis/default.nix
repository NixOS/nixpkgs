{ lib, buildPythonPackage, fetchPypi, nose }:

buildPythonPackage rec {
  pname = "proboscis";
  version = "1.2.6.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b822b243a7c82030fce0de97bdc432345941306d2c24ef227ca561dd019cd238";
  };

  propagatedBuildInputs = [ nose ];
  doCheck = false;

  meta = with lib; {
    description = "A Python test framework that extends Python's built-in unittest module and Nose with features from TestNG";
    homepage = "https://pypi.python.org/pypi/proboscis";
    license = licenses.asl20;
  };
}
