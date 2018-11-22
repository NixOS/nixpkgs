{ stdenv
, buildPythonPackage
, fetchPypi
, django
, six
, pycrypto
}:

buildPythonPackage rec {
  pname = "libthumbor";
  version = "1.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vjhszsf8wl9k16wyg2rfjycjnawzl7z8j39bhiysbz5x4lqg91b";
  };

  buildInputs = [ django ];
  propagatedBuildInputs = [ six pycrypto ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "libthumbor is the python extension to thumbor";
    homepage = https://github.com/heynemann/libthumbor;
    license = licenses.mit;
  };

}
