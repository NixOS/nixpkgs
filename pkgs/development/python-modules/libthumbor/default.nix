{ lib
, buildPythonPackage
, fetchPypi
, django
, six
, pycrypto
}:

buildPythonPackage rec {
  pname = "libthumbor";
  version = "2.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1PsiFZrTDVQqy8A3nkaM5LdPiBoriRgHkklTOiczN+g=";
  };

  buildInputs = [ django ];
  propagatedBuildInputs = [ six pycrypto ];

  doCheck = false;

  meta = with lib; {
    description = "libthumbor is the python extension to thumbor";
    homepage = "https://github.com/heynemann/libthumbor";
    license = licenses.mit;
  };

}
