{
  lib,
  asn1crypto,
  buildPythonPackage,
  cryptography,
  dnspython,
  fetchFromGitHub,
  gssapi,
  hatchling,
  ldap3,
  msldap,
  pyasn1,
  pytestCheckHook,
  pythonOlder,
  winacl,
}:

buildPythonPackage rec {
  pname = "bloodyad";
  version = "2.0.6";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "CravateRouge";
    repo = "bloodyAD";
    rev = "refs/tags/v${version}";
    hash = "sha256-o035D6GYG1Uf59tFAAMsMF9kiY3yE15EDOCkg4V4tr4=";
  };

  build-system = [ hatchling ];

  dependencies = [
    asn1crypto
    cryptography
    dnspython
    gssapi
    ldap3
    msldap
    pyasn1
    winacl
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "bloodyAD" ];

  disabledTests = [
    # Tests require network access
    "test_01AuthCreateUser"
    "test_02SearchAndGetChildAndGetWritable"
    "test_03UacOwnerGenericShadowGroupPasswordDCSync"
    "test_04ComputerRbcdGetSetAttribute"
    "test_06AddRemoveGetDnsRecord"
  ];

  meta = with lib; {
    description = "Module for Active Directory Privilege Escalations";
    homepage = "https://github.com/CravateRouge/bloodyAD";
    changelog = "https://github.com/CravateRouge/bloodyAD/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
