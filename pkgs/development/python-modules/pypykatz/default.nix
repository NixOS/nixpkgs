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
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "skelsec";
    repo = pname;
    rev = version;
    sha256 = "sha256-dTpkwBYEAITdyKsRTfeJk40hgO8+wmxD3d2XXkvWUpc=";
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
