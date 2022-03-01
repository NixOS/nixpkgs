{ lib
, asn1crypto
, asysocks
, buildPythonPackage
, fetchPypi
, oscrypto
, pythonOlder
}:

buildPythonPackage rec {
  pname = "minikerberos";
  version = "0.2.18";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-5bmuCbX4a69sP9SnHkB4OQrOHmFufUTlchHkgu6iBYk=";
  };

  propagatedBuildInputs = [
    asn1crypto
    asysocks
    oscrypto
  ];

  # no tests are published: https://github.com/skelsec/minikerberos/pull/5
  doCheck = false;

  pythonImportsCheck = [
    "minikerberos"
  ];

  meta = with lib; {
    description = "Kerberos manipulation library in Python";
    homepage = "https://github.com/skelsec/minikerberos";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
