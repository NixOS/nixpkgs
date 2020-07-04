{ lib, python, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "dnslib";
  version = "0.9.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a0fed3e139c12ee4884b19bcde1d4a170745bcabb6026397876e3236ce38b9db";
  };

  checkPhase = "VERSIONS=${python.interpreter} ./run_tests.sh";

  meta = with lib; {
    description = "Simple library to encode/decode DNS wire-format packets";
    license = licenses.bsd2;
    homepage = "https://bitbucket.org/paulc/dnslib/";
    maintainers = with maintainers; [ delroth ];
  };
}
