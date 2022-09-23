{ lib, python, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "dnslib";
  version = "0.9.21";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-IXabARWP5wvokSF1Q0nyg13M3yHVwBHOyfoopI+lVdQ=";
  };

  checkPhase = "VERSIONS=${python.interpreter} ./run_tests.sh";

  meta = with lib; {
    description = "Simple library to encode/decode DNS wire-format packets";
    license = licenses.bsd2;
    homepage = "https://bitbucket.org/paulc/dnslib/";
    maintainers = with maintainers; [ delroth ];
  };
}
