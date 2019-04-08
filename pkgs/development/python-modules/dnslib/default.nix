{ lib, python, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "dnslib";
  version = "0.9.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0w8spp4fnw63xx9zj77zvgk1qabd97ifrj6gap2j36gydnarr42c";
  };

  checkPhase = "VERSIONS=${python.interpreter} ./run_tests.sh";

  meta = with lib; {
    description = "Simple library to encode/decode DNS wire-format packets";
    license = licenses.bsd2;
    homepage = https://bitbucket.org/paulc/dnslib/;
    maintainers = with maintainers; [ delroth ];
  };
}
