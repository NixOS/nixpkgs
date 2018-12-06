{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, numpy
, scipy
, pytz
}:

buildPythonPackage rec {
  pname = "pyalgotrade";
  version = "0.16";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "a253617254194b91cfebae7bfd184cb109d4e48a8c70051b9560000a2c0f94b3";
  };

  propagatedBuildInputs = [ numpy scipy pytz ];

  meta = with stdenv.lib; {
    description = "Python Algorithmic Trading";
    homepage = http://gbeced.github.io/pyalgotrade/;
    license = licenses.asl20;
  };

}
