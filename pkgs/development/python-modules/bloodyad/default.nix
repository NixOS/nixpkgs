{ lib
, buildPythonPackage
, cryptography
, fetchFromGitHub
, gssapi
, hatchling
, ldap3
, pyasn1
, pytestCheckHook
, pythonOlder
, winacl
}:

buildPythonPackage rec {
  pname = "bloodyad";
  version = "1.1.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "CravateRouge";
    repo = "bloodyAD";
    rev = "refs/tags/v${version}";
    hash = "sha256-wnq+HTAPnC7pSGI2iytSyHmdqtUq2pUnNwZnsGX8CL4=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    cryptography
    gssapi
    ldap3
    pyasn1
    winacl
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "bloodyAD"
  ];

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
