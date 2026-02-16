{
  lib,
  buildPythonPackage,
  cryptography,
  dnspython,
  expiringdict,
  fetchFromGitHub,
  hatchling,
  importlib-resources,
  pem,
  publicsuffixlist,
  pyleri,
  pyopenssl,
  pytestCheckHook,
  requests,
  timeout-decorator,
  xmltodict,
}:

buildPythonPackage (finalAttrs: {
  pname = "checkdmarc";
  version = "5.13.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "domainaware";
    repo = "checkdmarc";
    tag = finalAttrs.version;
    hash = "sha256-Ub/B3IO7f5Ah2XNTJ90Y6whP+PIDCL7ucHGd5sWwJRk=";
  };

  pythonRelaxDeps = [
    "cryptography"
    "xmltodict"
  ];

  build-system = [ hatchling ];

  dependencies = [
    cryptography
    dnspython
    expiringdict
    importlib-resources
    pem
    publicsuffixlist
    pyleri
    pyopenssl
    requests
    timeout-decorator
    xmltodict
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "checkdmarc" ];

  enabledTestPaths = [ "tests.py" ];

  disabledTests = [
    # Tests require network access
    "testBIMI"
    "testDMARCPctLessThan100Warning"
    "testSPFMissingARecord"
    "testSPFMissingMXRecord"
    "testSplitSPFRecord"
    "testTooManySPFDNSLookups"
    "testTooManySPFVoidDNSLookups"
  ];

  meta = {
    description = "Parser for SPF and DMARC DNS records";
    homepage = "https://github.com/domainaware/checkdmarc";
    changelog = "https://github.com/domainaware/checkdmarc/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "checkdmarc";
  };
})
