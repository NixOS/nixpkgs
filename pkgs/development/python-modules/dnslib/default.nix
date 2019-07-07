{ lib, python, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "dnslib";
  version = "0.9.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "666bf55274a630a2925411c4ea9ca724529299bbe70f91979ad99c72c5e5099e";
  };

  checkPhase = "VERSIONS=${python.interpreter} ./run_tests.sh";

  meta = with lib; {
    description = "Simple library to encode/decode DNS wire-format packets";
    license = licenses.bsd2;
    homepage = https://bitbucket.org/paulc/dnslib/;
    maintainers = with maintainers; [ delroth ];
  };
}
