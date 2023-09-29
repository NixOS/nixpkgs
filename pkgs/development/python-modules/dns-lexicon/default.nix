{ buildPythonPackage
, fetchFromGitHub
, poetry-core
, beautifulsoup4
, cryptography
, importlib-metadata
, pyyaml
, requests
, tldextract
, pytestCheckHook
, pytest-vcr
# Optional depedencies
, boto3
, localzone
, softlayer
, zeep
, dnspython
, oci
, lib
}:

buildPythonPackage rec {
  pname = "dns_lexicon";
  version = "3.14.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Analogj";
    repo = "lexicon";
    rev = "v${version}";
    hash = "sha256-flK2G9mdUWMUACQPo6TqYZ388EacIqkq//tCzUS+Eo8=";
  };

  nativeBuildInputs = [ poetry-core ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-vcr
  ] ++ passthru.optional-dependencies.full;

  propagatedBuildInputs = [
    beautifulsoup4
    cryptography
    importlib-metadata
    pyyaml
    requests
    tldextract
  ];

  passthru.optional-dependencies = {
    route53 = [ boto3 ];
    localzone = [ localzone ];
    softlayer = [ softlayer ];
    ddns = [ dnspython ];
    duckdns = [ dnspython ];
    oci = [ oci ];
    full = [ boto3 localzone softlayer zeep dnspython oci ];
  };

  pytestFlagsArray = [
    "tests/"
  ];

  disabledTestPaths = [
    # Needs network access
    "tests/providers/test_auto.py"

    # Needs network access (and an API token)
    "tests/providers/test_namecheap.py"
  ];

  pythonImportsCheck = [
    "lexicon"
  ];

  meta = with lib; {
    description = "Manipulate DNS records on various DNS providers in a standardized way";
    homepage = "https://github.com/AnalogJ/lexicon";
    changelog = "https://github.com/AnalogJ/lexicon/blob/v${version}/CHANGELOG.md";
    maintainers = with maintainers; [ aviallon ];
    license = with licenses; [ mit ];
  };

}
