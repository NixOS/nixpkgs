{ lib
, asn1crypto
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "asysocks";
  version = "0.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-j0UWCI6+x/CNjFSeXnXnqGtB5gQ6+SC6SJXPP2xlQVA=";
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
