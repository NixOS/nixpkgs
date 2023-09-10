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
  version = "0.6.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uOOPDVlx8EKgkCJmZOQxIlI0UBMNzuh/ESoIoa2TmNM=";
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
    changelog = "https://github.com/skelsec/pypykatz/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
