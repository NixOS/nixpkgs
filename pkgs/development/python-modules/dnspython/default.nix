{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "dnspython";
  version = "2.0.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "044af09374469c3a39eeea1a146e8cac27daec951f1f1f157b1962fc7cb9d1b7";
  };

  # needs networking for some tests
  doCheck = false;
  pythonImportsCheck = [ "dns" ];

  meta = with lib; {
    description = "A DNS toolkit for Python";
    homepage = "http://www.dnspython.org";
    license = with licenses; [ isc ];
  };
}
