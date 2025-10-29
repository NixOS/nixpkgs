{
  lib,
  aesedb,
  aiosmb,
  aiowinreg,
  buildPythonPackage,
  fetchPypi,
  minidump,
  minikerberos,
  msldap,
  pythonOlder,
  winsspi,
}:

buildPythonPackage rec {
  pname = "pypykatz";
  version = "0.6.11";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yNw/o0Q97Hb8SNmAPX6/KfT1/YrQRoJZJ2XQhw9wRRg=";
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

  pythonImportsCheck = [ "pypykatz" ];

  meta = with lib; {
    description = "Mimikatz implementation in Python";
    mainProgram = "pypykatz";
    homepage = "https://github.com/skelsec/pypykatz";
    changelog = "https://github.com/skelsec/pypykatz/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
