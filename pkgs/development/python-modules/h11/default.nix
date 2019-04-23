{ lib, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "h11";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "acca6a44cb52a32ab442b1779adf0875c443c689e9e028f8d831a3769f9c5208";
  };

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "Pure-Python, bring-your-own-I/O implementation of HTTP/1.1";
    license = licenses.mit;
  };
}
