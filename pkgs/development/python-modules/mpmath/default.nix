{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "mpmath";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04d14803b6875fe6d69e6dccea87d5ae5599802e4b1df7997bddd2024001050c";
  };

  # error: invalid command 'test'
  doCheck = false;

  meta = with stdenv.lib; {
    homepage    = http://mpmath.googlecode.com;
    description = "A pure-Python library for multiprecision floating arithmetic";
    license     = licenses.bsd3;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };

}
