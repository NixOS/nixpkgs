{ lib, python, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "dnslib";
  version = "0.9.19";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a6e36ca96c289e2cb4ac6aa05c037cbef318401ba8ff04a8676892ca79749c77";
  };

  checkPhase = "VERSIONS=${python.interpreter} ./run_tests.sh";

  meta = with lib; {
    description = "Simple library to encode/decode DNS wire-format packets";
    license = licenses.bsd2;
    homepage = "https://bitbucket.org/paulc/dnslib/";
    maintainers = with maintainers; [ delroth ];
  };
}
