{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "dnspython";
  version = "1.16.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "36c5e8e38d4369a08b6780b7f27d790a292b2b08eea01607865bf0936c558e01";
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
