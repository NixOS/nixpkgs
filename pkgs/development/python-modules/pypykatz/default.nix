{ lib
, aiosmb
, aiowinreg
, buildPythonPackage
, fetchPypi
, minidump
, minikerberos
, msldap
, winsspi
}:

buildPythonPackage rec {
  pname = "pypykatz";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1p8v4Qi0MNqMUpcErWnxveYu4d4N5BUBCDBsw1xX96I=";
  };

  propagatedBuildInputs = [
    aiosmb
    aiowinreg
    minikerberos
    msldap
    winsspi
    minidump
  ];

  # Project doesn't have tests
  doCheck = false;
  pythonImportsCheck = [ "pypykatz" ];

  meta = with lib; {
    description = "Mimikatz implementation in Python";
    homepage = "https://github.com/skelsec/pypykatz";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
