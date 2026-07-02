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
  version = "5.17.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "domainaware";
    repo = "checkdmarc";
    tag = finalAttrs.version;
    hash = "sha256-OI96936+4Jcx3VuPmHI2tcIssPxC7ofmLwWcvZxMw7E=";
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

  disabledTests = [
    # Tests require network access
    "testBIMI"
    "testDMARCPctLessThan100Warning"
    "testSPFMissingARecord"
    "testSPFMissingMXRecord"
    "testSplitSPFRecord"
    "testTooManySPFDNSLookups"
    "testTooManySPFVoidDNSLookups"
    "testDNSSEC"
    "testDnssecFalseWhenNoKey"
    "testGetDnskeyCache"
    "testIncludeMissingSPF"
    "testKnownGood"
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
