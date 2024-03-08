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
  version = "4.8.4";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "domainaware";
    repo = "checkdmarc";
    rev = "refs/tags/${version}";
    hash = "sha256-NNB5dYQzzdNapjP4mtpCW08BzfZ+FFRESUtpxCOzrdk=";
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

