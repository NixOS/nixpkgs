{
  lib,
  beautifulsoup4,
  boto3,
  buildPythonPackage,
  cryptography,
  dnspython,
  fetchFromGitHub,
  importlib-metadata,
  localzone,
  oci,
  poetry-core,
  pyotp,
  pytest-vcr,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  requests,
  softlayer,
  tldextract,
  zeep,
}:

buildPythonPackage rec {
  pname = "dns_lexicon";
  version = "3.16.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Analogj";
    repo = "lexicon";
    rev = "refs/tags/v${version}";
    hash = "sha256-79/zz0TOCpx26TEo6gi9JDBQeVW2azWnxAjWr/FGRLA=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    beautifulsoup4
    cryptography
    pyotp
    pyyaml
    requests
    tldextract
  ] ++ lib.optionals (pythonOlder "3.10") [ importlib-metadata ];

  passthru.optional-dependencies = {
    route53 = [ boto3 ];
    localzone = [ localzone ];
    softlayer = [ softlayer ];
    ddns = [ dnspython ];
    duckdns = [ dnspython ];
    oci = [ oci ];
    full = [
      boto3
      dnspython
      localzone
      oci
      softlayer
      zeep
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-vcr
  ] ++ passthru.optional-dependencies.full;

  pytestFlagsArray = [ "tests/" ];

  disabledTestPaths = [
    # Needs network access
    "tests/providers/test_auto.py"
    # Needs network access (and an API token)
    "tests/providers/test_namecheap.py"
  ];

  disabledTests = [
    # Tests want to download Public Suffix List
    "test_client_legacy_init"
    "test_client_basic_init"
    "test_client_init"
    "test_client_parse_env"
    "test_missing"
    "action_is_correctly"
  ];

  pythonImportsCheck = [ "lexicon" ];

  meta = with lib; {
    description = "Manipulate DNS records on various DNS providers in a standardized way";
    mainProgram = "lexicon";
    homepage = "https://github.com/AnalogJ/lexicon";
    changelog = "https://github.com/AnalogJ/lexicon/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ aviallon ];
  };
}
