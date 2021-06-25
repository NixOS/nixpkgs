{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "dnspython";
  version = "2.1.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "e4a87f0b573201a0f3727fa18a516b055fd1107e0e5477cded4a2de497df1dd4";
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
