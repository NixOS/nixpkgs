{
  lib,
  aiohttp,
  aioitertools,
  botocore,
  buildPythonPackage,
  dill,
  fetchFromGitHub,
  flask,
  flask-cors,
  awscli,
  moto,
  boto3,
  setuptools,
  pytest-asyncio,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  wrapt,
}:

buildPythonPackage rec {
  pname = "aiobotocore";
  version = "2.15.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "aiobotocore";
    rev = "refs/tags/${version}";
    hash = "sha256-kPSkvvXBBwnWrdf0jmDNiTG6T1qpm5pNcPDHpnMFdmc=";
  };

  # Relax version constraints: aiobotocore works with newer botocore versions
  # the pinning used to match some `extras_require` we're not using.
  pythonRelaxDeps = [ "botocore" ];

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    aioitertools
    botocore
    wrapt
  ];

  optional-dependencies = {
    awscli = [ awscli ];
    boto3 = [ boto3 ];
  };

  nativeCheckInputs = [
    dill
    flask
    flask-cors
    moto
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiobotocore" ];

  disabledTestPaths = [
    # Tests require network access
    "tests/boto_tests/test_signers.py"
    "tests/python3.8/"
    "tests/test_basic_s3.py"
    "tests/test_batch.py"
    "tests/test_dynamodb.py"
    "tests/test_ec2.py"
    "tests/test_eventstreams.py"
    "tests/test_lambda.py"
    "tests/test_monitor.py"
    "tests/test_mturk.py"
    "tests/test_patches.py"
    "tests/test_sns.py"
    "tests/test_sqs.py"
    "tests/test_version.py"
    "tests/test_waiter.py"
  ];

  disabledTests =
    [
      "test_get_credential"
      "test_load_sso_credentials_without_cache"
      "test_load_sso_credentials"
      "test_required_config_not_set"
      "test_sso_cred_fetcher_raises_helpful_message_on_unauthorized_exception"
      "test_sso_credential_fetcher_can_fetch_credentials"
    ]
    ++ lib.optionals (pythonAtLeast "3.12.") [
      # AttributeError: 'called_with' is not a valid assertion. Use a spec for the mock if 'called_with' is meant to be an attribute.
      "test_max_rate_updated_on_success_response"
      "test_max_rate_cant_exceed_20_percent_max"
    ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Python client for amazon services";
    homepage = "https://github.com/aio-libs/aiobotocore";
    changelog = "https://github.com/aio-libs/aiobotocore/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ teh ];
  };
}
