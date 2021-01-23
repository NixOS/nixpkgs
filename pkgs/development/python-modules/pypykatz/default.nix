{ lib
, aiowinreg
, buildPythonPackage
, fetchFromGitHub
, minidump
, minikerberos
, msldap
, winsspi
}:

buildPythonPackage rec {
  pname = "pypykatz";
  version = "0.3.15";

  src = fetchFromGitHub {
    owner = "skelsec";
    repo = pname;
    rev = version;
    sha256 = "0bx2jdcfr1pdy3jgzg8fr5id9ffl2m1nc81dqhcplxdj8p214yri";
  };

  propagatedBuildInputs = [
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
