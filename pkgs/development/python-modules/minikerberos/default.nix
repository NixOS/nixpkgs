{ lib
, asn1crypto
, asysocks
, buildPythonPackage
, fetchPypi
, oscrypto
}:

buildPythonPackage rec {
  pname = "minikerberos";
  version = "0.2.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-MND7r4Gkx9RnEMgEl62QXFYr1NEloihQ2HeU9hyhsx8=";
  };

  propagatedBuildInputs = [
    asn1crypto
    asysocks
    oscrypto
  ];

  # no tests are published: https://github.com/skelsec/minikerberos/pull/5
  doCheck = false;

  pythonImportsCheck = [ "minikerberos" ];

  meta = with lib; {
    description = "Kerberos manipulation library in Python";
    homepage = "https://github.com/skelsec/minikerberos";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
