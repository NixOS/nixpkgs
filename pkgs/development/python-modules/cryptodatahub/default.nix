{
  lib,
  asn1crypto,
  attrs,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitLab,
  pyfakefs,
  python-dateutil,
  setuptools,
  setuptools-scm,
  unittestCheckHook,
  urllib3,
}:

buildPythonPackage rec {
  pname = "cryptodatahub";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "coroner";
    repo = "cryptodatahub";
    tag = "v${version}";
    hash = "sha256-DQspaa9GsnRjETKUca2i91iBPbT4qATmKiL8M0nBP/A=";
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
    unittestCheckHook
  ];

  pythonImportsCheck = [ "cryptodatahub" ];

  preCheck = ''
    # failing tests
    rm test/updaters/test_common.py
    # Tests require network access
    rm test/common/test_utils.py
  '';

  meta = {
    description = "Repository of cryptography-related data";
    homepage = "https://gitlab.com/coroner/cryptodatahub";
    changelog = "https://gitlab.com/coroner/cryptodatahub/-/blob/${src.tag}/CHANGELOG.rst";
    license = lib.licenses.mpl20;
    teams = with lib.teams; [ ngi ];
  };
}
