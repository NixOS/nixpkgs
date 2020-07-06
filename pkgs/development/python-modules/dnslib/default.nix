{ lib, python, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "dnslib";
  version = "0.9.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1yz63cgiv910wkx90if09bql1n63lq6hy4wfpqink0q4sxy0mlpv";
  };

  checkPhase = "VERSIONS=${python.interpreter} ./run_tests.sh";

  meta = with lib; {
    description = "Simple library to encode/decode DNS wire-format packets";
    license = licenses.bsd2;
    homepage = "https://bitbucket.org/paulc/dnslib/";
    maintainers = with maintainers; [ delroth ];
  };
}
