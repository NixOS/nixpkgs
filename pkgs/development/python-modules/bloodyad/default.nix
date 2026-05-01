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
  version = "2.5.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CravateRouge";
    repo = "bloodyAD";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6ZSJTupjVhvyU9G/eePJiXk16w9HwpsOFwdwTSLb7tU=";
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
  postPatch = lib.optionals stdenv.hostPlatform.isDarwin ''
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
  ];

  disabledTestPaths = [
    # TypeError: applyFormatters() takes 1 positional argument but 2 were given
    # https://github.com/CravateRouge/bloodyAD/issues/98
    "tests/test_formatters.py"
  ];

  meta = {
    description = "Module for Active Directory Privilege Escalations";
    homepage = "https://github.com/CravateRouge/bloodyAD";
    changelog = "https://github.com/CravateRouge/bloodyAD/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
