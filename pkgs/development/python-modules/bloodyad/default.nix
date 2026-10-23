{
  lib,
  stdenv,
  asn1crypto,
  badldap,
  buildPythonPackage,
  certipy,
  cryptography,
  dnspython,
  fetchFromGitHub,
  hatchling,
  kerbad,
  pytestCheckHook,
  winacl,
}:

buildPythonPackage (finalAttrs: {
  pname = "bloodyad";
  version = "2.5.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CravateRouge";
    repo = "bloodyAD";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J4vQX8z6mqSkwnonNOVYJZGyA63p5QdIkRAiiSld6yg=";
  };

  pythonRelaxDeps = [ "cryptography" ];

  pythonRemoveDeps = [
    "kerbad"
    "badldap"
  ];

  build-system = [ hatchling ];

  # Upstream provides two package scripts: bloodyad and bloodyAD,
  # but this causes a FileAlreadyExists error during installation
  # on Darwin (case-insensitive filesystem).
  # https://github.com/CravateRouge/bloodyAD/issues/99
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace pyproject.toml \
      --replace-fail "bloodyAD = \"bloodyAD.main:main\"" ""
  '';

  dependencies = [
    asn1crypto
    badldap
    cryptography
    dnspython
    kerbad
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
    "test_04ComputerRbcdRestoreGetSetAttribute"
    # AssertionError
    "test_applyFormatters_with_trustDirection_single_item_list"
    "test_applyFormatters_with_userAccountControl_single_value"
  ];

  disabledTestPaths = [
    # Missing file
    "tests/test_functional.py"
  ];

  meta = {
    description = "Module for Active Directory Privilege Escalations";
    homepage = "https://github.com/CravateRouge/bloodyAD";
    changelog = "https://github.com/CravateRouge/bloodyAD/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
