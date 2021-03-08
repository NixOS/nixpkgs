{ lib
, asn1crypto
, asysocks
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "minikerberos";
  version = "0.2.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16bbyihap2ygsi7xg58rwdn14ms1j0jy2kxbdljpg39s9q1rz6ps";
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
