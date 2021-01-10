{ lib
, asn1crypto
, asysocks
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "minikerberos";
  version = "0.2.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08ngf55pbnzyqkgffzxix6ldal9l38d2jjn9rvxkg88ygxsalfvm";
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
