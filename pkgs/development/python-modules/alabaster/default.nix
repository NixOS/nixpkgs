{ lib, buildPythonPackage, fetchFromPyPI
, pygments }:

buildPythonPackage rec {
  pname = "alabaster";
  version = "0.7.12";

  src = fetchFromPyPI {
    inherit pname version;
    sha256 = "a661d72d58e6ea8a57f7a86e37d86716863ee5e92788398526d58b26a4e4dc02";
  };

  propagatedBuildInputs = [ pygments ];

  # No tests included
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/bitprophet/alabaster";
    description = "A Sphinx theme";
    license = licenses.bsd3;
  };
}
