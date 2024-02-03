{ lib
, buildPythonPackage
, fetchPypi
, django
, six
, pycrypto
, pythonOlder
}:

buildPythonPackage rec {
  pname = "libthumbor";
  version = "2.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1PsiFZrTDVQqy8A3nkaM5LdPiBoriRgHkklTOiczN+g=";
  };

  buildInputs = [
    django
  ];

  propagatedBuildInputs = [
    six
    pycrypto
  ];

  doCheck = false;

  pythonImportsCheck = [
    "libthumbor"
  ];

  meta = with lib; {
    description = "Python extension to thumbor";
    homepage = "https://github.com/heynemann/libthumbor";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
