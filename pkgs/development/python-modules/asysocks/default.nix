{ lib
, asn1crypto
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "asysocks";
  version = "0.2.9";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zg3xEveyEOisk8s4R/36Ly9JH5xDvVsjS4FZIxHOlZ8=";
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
    changelog = "https://github.com/skelsec/asysocks/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
