{ lib
, buildPythonPackage
, cryptography
, dnspython
, expiringdict
, fetchFromGitHub
, hatchling
, publicsuffixlist
, pyleri
, iana-etc
, pytestCheckHook
, pythonOlder
, requests
, timeout-decorator
}:

buildPythonPackage rec {
  pname = "checkdmarc";
  version = "4.8.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "domainaware";
    repo = "checkdmarc";
    # https://github.com/domainaware/checkdmarc/issues/102
    rev = "d0364ceef3cfd41052273913369e3831cb6fe4fd";
    hash = "sha256-OSljewDeyJtoxkCQjPU9wIsNhhxumHmeu9GHvRD4DRY=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    cryptography
    dnspython
    expiringdict
    publicsuffixlist
    pyleri
    requests
    timeout-decorator
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "checkdmarc"
  ];

  pytestFlagsArray = [
    "tests.py"
  ];

  disabledTests = [
    # Tests require network access
    "testDMARCPctLessThan100Warning"
    "testSPFMissingARecord"
    "testSPFMissingMXRecord"
    "testSplitSPFRecord"
    "testTooManySPFDNSLookups"
    "testTooManySPFVoidDNSLookups"
  ];

  meta = with lib; {
    description = "A parser for SPF and DMARC DNS records";
    homepage = "https://github.com/domainaware/checkdmarc";
    changelog = "https://github.com/domainaware/checkdmarc/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}

