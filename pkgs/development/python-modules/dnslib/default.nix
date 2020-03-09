{ lib, python, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "dnslib";
  version = "0.9.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c206f09948f3ad17884adffdb552b700072c6022fa59744a0f0606114c475e19";
  };

  checkPhase = "VERSIONS=${python.interpreter} ./run_tests.sh";

  meta = with lib; {
    description = "Simple library to encode/decode DNS wire-format packets";
    license = licenses.bsd2;
    homepage = https://bitbucket.org/paulc/dnslib/;
    maintainers = with maintainers; [ delroth ];
  };
}
