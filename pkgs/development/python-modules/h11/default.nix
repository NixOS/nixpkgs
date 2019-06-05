{ lib, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "h11";
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1qfad70h59hya21vrzz8dqyyaiqhac0anl2dx3s3k80gpskvrm1k";
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
