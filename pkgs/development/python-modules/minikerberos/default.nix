{ lib
, asn1crypto
, asysocks
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "minikerberos";
  version = "0.2.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-OC+Cnk47GFzK1QaDEDxntRVrakpFiBuNelM/R5t/AUY=";
  };

  propagatedBuildInputs = [
    asn1crypto
    asysocks
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
