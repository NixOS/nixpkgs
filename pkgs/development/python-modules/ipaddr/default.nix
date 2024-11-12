{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "ipaddr";
  version = "2.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ml8r8z3f0mnn381qs1snbffa920i9ycp6mm2am1d3aqczkdz4j0";
  };

  checkPhase = ''
    python ipaddr_test.py
  '';

  meta = with lib; {
    description = "IP address manipulation library";
    homepage = "https://github.com/google/ipaddr-py";
    license = licenses.asl20;
    maintainers = [ maintainers.astro ];
  };
}
