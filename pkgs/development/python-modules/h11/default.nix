{ lib, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "h11";
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "1n9hsm1n2qq32j3hh9wj93w738bwa5nqyzxjwvirz03gp8fbn3qw";
  };

  buildInputs = [ pytest ];

  meta = with lib; {
    description = "Pure-Python, bring-your-own-I/O implementation of HTTP/1.1";
    license = licenses.mit;
  };
}
