{ stdenv
, buildPythonPackage
, fetchPypi
, django
, six
, pycrypto
}:

buildPythonPackage rec {
  pname = "libthumbor";
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ed4fe5f27f8f90e7285b7e6dce99c1b67d43a140bf370e989080b43d80ce25f0";
  };

  buildInputs = [ django ];
  propagatedBuildInputs = [ six pycrypto ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "libthumbor is the python extension to thumbor";
    homepage = "https://github.com/heynemann/libthumbor";
    license = licenses.mit;
  };

}
