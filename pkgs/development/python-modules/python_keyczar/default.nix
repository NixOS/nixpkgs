{ stdenv
, buildPythonPackage
, fetchPypi
, pyasn1
, pycrypto
}:

buildPythonPackage rec {
  pname = "python-keyczar";
  version = "0.71c";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18mhiwqq6vp65ykmi8x3i5l3gvrvrrr8z2kv11z1rpixmyr7sw1p";
  };

  buildInputs = [ pyasn1 pycrypto ];

  meta = with stdenv.lib; {
    description = "Toolkit for safe and simple cryptography";
    homepage    = https://pypi.python.org/pypi/python-keyczar;
    license     = licenses.asl20;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };

}
