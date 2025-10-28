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
  pythonOlder,
  requests,
  timeout-decorator,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "checkdmarc";
  version = "5.10.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "domainaware";
    repo = "checkdmarc";
    tag = version;
    hash = "sha256-XbBdBef3+kt26XP5GDH5rgHYGh8xIjHUUVOcdeVICLs=";
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

  meta = with lib; {
    description = "Parser for SPF and DMARC DNS records";
    homepage = "https://github.com/domainaware/checkdmarc";
    changelog = "https://github.com/domainaware/checkdmarc/blob/${src.tag}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "checkdmarc";
  };
}
