{ lib, buildPythonPackage, fetchPypi, }:

buildPythonPackage rec {
  pname = "pyasn1";
  version = "0.4.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "aef77c9fb94a3ac588e87841208bdec464471d9871bd5050a287cc9a475cd0ba";
  };

  pythonImportsCheck = [ "pyasn1" ];

  meta = with lib; {
    description = "Generic ASN.1 library for Python";
    homepage = "https://github.com/etingof/pyasn1";
    license = licenses.bsd2;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
