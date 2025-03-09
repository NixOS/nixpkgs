{
  lib,
  buildPythonPackage,
  cryptography,
  dnspython,
  expiringdict,
  fetchFromGitHub,
  hatchling,
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
  version = "5.7.8";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "domainaware";
    repo = "checkdmarc";
    rev = "refs/tags/${version}";
    hash = "sha256-fqSRqiakwFk1Cfb79oOEBbPF/fbtumuV7M6Mjl09Vmw=";
  };

  pythonRelaxDeps = [ "xmltodict" ];

  build-system = [ hatchling ];

  dependencies = [
    cryptography
    dnspython
    expiringdict
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

  pytestFlagsArray = [ "tests.py" ];

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
    mainProgram = "checkdmarc";
    homepage = "https://github.com/domainaware/checkdmarc";
    changelog = "https://github.com/domainaware/checkdmarc/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
