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
  version = "0.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1lyvypi1g4l9fq1f9q05bdn6vq8y5y9ghmb6ziqdycr0lxn7lfdd";
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
