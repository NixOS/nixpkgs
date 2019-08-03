{ stdenv
, buildPythonPackage
, fetchPypi
, pyasn1
, pycrypto
}:

buildPythonPackage rec {
  pname = "python-keyczar";
  version = "0.716";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f9b614112dc8248af3d03b989da4aeca70e747d32fe7e6fce9512945365e3f83";
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
