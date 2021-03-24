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
  version = "0.4.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0il5sj47wyf9gn76alm8v1l63rqw2vsd27v6f7q1dpn0wq209syi";
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
