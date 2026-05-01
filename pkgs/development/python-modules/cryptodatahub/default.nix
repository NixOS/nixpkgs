{
  lib,
  asn1crypto,
  attrs,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitLab,
  pyfakefs,
  pytestCheckHook,
  python-dateutil,
  setuptools,
  setuptools-scm,
  urllib3,
}:

buildPythonPackage (finalAttrs: {
  pname = "cryptodatahub";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "coroner";
    repo = "cryptodatahub";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NxLUy16u8UL6klvVuXPIIlNuiehlomPsmiS4K5QT9cE=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    asn1crypto
    attrs
    python-dateutil
    urllib3
  ];

  nativeCheckInputs = [
    beautifulsoup4
    pyfakefs
    pytestCheckHook
  ];

  pythonImportsCheck = [ "cryptodatahub" ];

  disabledTests = [
    # fails due to certificate expiry
    # see https://gitlab.com/coroner/cryptodatahub/-/work_items/38
    "test_validity"
    # pytest incorrectly collects abstract base classes
    "TestClasses"
  ];

  disabledTestPaths = [
    # failing tests
    "test/updaters/test_common.py"
    # Tests require network access
    "test/common/test_utils.py"
  ];

  meta = {
    description = "Repository of cryptography-related data";
    homepage = "https://gitlab.com/coroner/cryptodatahub";
    changelog = "https://gitlab.com/coroner/cryptodatahub/-/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    license = lib.licenses.mpl20;
    teams = with lib.teams; [ ngi ];
  };
})
