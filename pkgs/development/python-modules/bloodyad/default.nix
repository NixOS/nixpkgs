{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  asn1crypto,
  cryptography,
  dnspython,
  kerbad,
  badldap,
  winacl,

  # test
  certipy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "bloodyad";
  version = "2.1.21";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CravateRouge";
    repo = "bloodyAD";
    tag = "v${version}";
    hash = "sha256-9yzKYSEmaPMv6AWhgr4UPPEx8s75Pg/hwqJnV29WocM=";
  };

  pythonRelaxDeps = [ "cryptography" ];

  pythonRemoveDeps = [
    "kerbad"
    "badldap"
  ];

  build-system = [ hatchling ];

  dependencies = [
    asn1crypto
    cryptography
    dnspython
    kerbad
    badldap
    winacl
  ];

  nativeCheckInputs = [
    certipy
    pytestCheckHook
  ];

  pythonImportsCheck = [ "bloodyAD" ];

  disabledTests = [
    # Tests require network access
    "test_kerberos_authentications"
    "test_01AuthCreateUser"
    "test_02SearchAndGetChildAndGetWritable"
    "test_03UacOwnerGenericShadowGroupPasswordDCSync"
    "test_04ComputerRbcdGetSetAttribute"
    "test_06AddRemoveGetDnsRecord"
    "test_certificate_authentications"
  ];

  meta = {
    description = "Module for Active Directory Privilege Escalations";
    homepage = "https://github.com/CravateRouge/bloodyAD";
    changelog = "https://github.com/CravateRouge/bloodyAD/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
