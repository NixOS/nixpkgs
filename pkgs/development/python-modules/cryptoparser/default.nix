{
  lib,
  asn1crypto,
  attrs,
  buildPythonPackage,
  cryptodatahub,
  fetchFromGitLab,
  pyfakefs,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
  urllib3,
}:

buildPythonPackage (finalAttrs: {
  pname = "cryptoparser";
  version = "1.6.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "coroner";
    repo = "cryptoparser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vOTH4QDP2mkyWxBvBhd7iLHW5myJm++vQlzUXbOR0oA=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    asn1crypto
    attrs
    cryptodatahub
    urllib3
  ];

  env.PYTHONDONTWRITEBYTECODE = 1;

  nativeCheckInputs = [
    pyfakefs
    pytestCheckHook
  ];

  disabledTests = [
    # pytest incorrectly collects abstract base classes
    "TestCasesBasesHttpHeader"
  ];

  postInstall = ''
    find $out -name __pycache__ -type d | xargs rm -rv
  '';

  pythonImportsCheck = [ "cryptoparser" ];

  passthru.updateScript = ../cryptodatahub/update.sh;

  meta = {
    description = "Security protocol parser and generator";
    homepage = "https://gitlab.com/coroner/cryptoparser";
    changelog = "https://gitlab.com/coroner/cryptoparser/-/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    license = lib.licenses.mpl20;
    teams = with lib.teams; [ ngi ];
  };
})
