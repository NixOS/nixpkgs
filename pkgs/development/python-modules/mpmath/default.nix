{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "mpmath";
  version = "0.19";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08ijsr4ifrqv3cjc26mkw0dbvyygsa99in376hr4b96ddm1gdpb8";
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
