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
  version = "0.20";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "7927c87af202869155280a93ff6ee934bb5b46cdb1f20b70f7407337f8541cbd";
  };

  propagatedBuildInputs = [ numpy scipy pytz ];

  meta = with stdenv.lib; {
    description = "Python Algorithmic Trading";
    homepage = http://gbeced.github.io/pyalgotrade/;
    license = licenses.asl20;
  };

}
