{
  lib,
  asn1crypto,
  buildPythonPackage,
  certipy,
  cryptography,
  dnspython,
  fetchFromGitHub,
  hatchling,
  minikerberos-bad,
  msldap-bad,
  pyasn1,
  pytestCheckHook,
  pythonOlder,
  winacl,
}:

buildPythonPackage rec {
  pname = "bloodyad";
  version = "2.1.18";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "CravateRouge";
    repo = "bloodyAD";
    tag = "v${version}";
    hash = "sha256-4/5cAYt3IhRxbd8bSXlyvCOCMLIJjWxWnke0vslyD2Y=";
  };

  pythonRelaxDeps = [ "cryptography" ];

  pythonRemoveDeps = [
    "minikerberos-bad"
    "msldap-bad"
  ];

  build-system = [ hatchling ];

  dependencies = [
    asn1crypto
    cryptography
    dnspython
    minikerberos-bad
    msldap-bad
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

  meta = with lib; {
    description = "Module for Active Directory Privilege Escalations";
    homepage = "https://github.com/CravateRouge/bloodyAD";
    changelog = "https://github.com/CravateRouge/bloodyAD/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
