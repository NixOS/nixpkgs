{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "ipaddr";
  version = "2.1.11";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1dwq3ngsapjc93fw61rp17fvzggmab5x1drjzvd4y4q0i255nm8v";
  };

  meta = with stdenv.lib; {
    description = "Google's IP address manipulation library";
    homepage = http://code.google.com/p/ipaddr-py/;
    license = licenses.asl20;
  };

}
