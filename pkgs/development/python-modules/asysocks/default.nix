{ lib
, asn1crypto
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "asysocks";
  version = "0.1.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-I9X8+ucadYJsPteHvZsbw7GJ7DdliWG86DyemUVeNUw=";
  };

  propagatedBuildInputs = [
    asn1crypto
  ];

  # Upstream hasn't release the tests yet
  doCheck = false;

  pythonImportsCheck = [
    "asysocks"
  ];

  meta = with lib; {
    description = "Python Socks4/5 client and server library";
    homepage = "https://github.com/skelsec/asysocks";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
