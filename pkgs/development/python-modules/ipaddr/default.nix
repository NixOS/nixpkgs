{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "ipaddr";
  version = "2.2.0";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ml8r8z3f0mnn381qs1snbffa920i9ycp6mm2am1d3aqczkdz4j0";
  };

  meta = with stdenv.lib; {
    description = "Google's IP address manipulation library";
    homepage = "https://github.com/google/ipaddr-py";
    license = licenses.asl20;
  };

}
