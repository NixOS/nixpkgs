{ lib
, aesedb
, aiosmb
, aiowinreg
, buildPythonPackage
, fetchPypi
, minidump
, minikerberos
, msldap
, pythonOlder
, winsspi
}:

buildPythonPackage rec {
  pname = "pypykatz";
  version = "0.6.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-djk8b7/H23aDmyGaM60goAcpfZQrpftOIIRKnJjFz50=";
  };

  propagatedBuildInputs = [
    aesedb
    aiosmb
    aiowinreg
    minikerberos
    msldap
    winsspi
    minidump
  ];

  # Project doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "pypykatz"
  ];

  meta = with lib; {
    description = "Mimikatz implementation in Python";
    homepage = "https://github.com/skelsec/pypykatz";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
