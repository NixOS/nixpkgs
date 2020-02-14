{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "mpmath";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fc17abe05fbab3382b61a123c398508183406fa132e0223874578e20946499f6";
  };

  # error: invalid command 'test'
  doCheck = false;

  meta = with stdenv.lib; {
    homepage    = "http://mpmath.org/";
    description = "A pure-Python library for multiprecision floating arithmetic";
    license     = licenses.bsd3;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };

}
