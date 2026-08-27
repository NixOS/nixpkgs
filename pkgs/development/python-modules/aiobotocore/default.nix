{
  lib,
  aiohttp,
  aioitertools,
  anyio,
  awscli,
  boto3,
  botocore,
  buildPythonPackage,
  dill,
  fetchFromGitHub,
  hatch-fancy-pypi-readme,
  hatchling,
  httpx,
  jmespath,
  moto,
  multidict,
  pytest-mock,
  pytestCheckHook,
  python-dateutil,
  time-machine,
  tiny-proxy,
  trustme,
  urllib3,
  werkzeug,
  wrapt,
}:

buildPythonPackage rec {
  pname = "aiobotocore";
  version = "3.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "aiobotocore";
    tag = version;
    hash = "sha256-VlQS47FmjFHq3Q2VGa4nGPPnG7qhFgEVxovhCuh7rxI=";
  };

  # Relax version constraints: aiobotocore works with newer botocore versions
  # the pinning used to match some `extras_require` we're not using.
  pythonRelaxDeps = [ "botocore" ];

  build-system = [
    hatch-fancy-pypi-readme
    hatchling
  ];

  dependencies = [
    aiohttp
    aioitertools
    botocore
    python-dateutil
    jmespath
    multidict
    urllib3
    wrapt
  ];

  optional-dependencies = {
    awscli = [ awscli ];
    boto3 = [ boto3 ];
    httpx = [ httpx ];
  };

  nativeCheckInputs = [
    anyio
    dill
    moto
    pytest-mock
    pytestCheckHook
    time-machine
    tiny-proxy
    trustme
    werkzeug
  ]
  ++ moto.optional-dependencies.server;

  pythonImportsCheck = [ "aiobotocore" ];

  disabledTests = [
    # TypeError: sequence item 1: expected str instance, MagicMock found
    "test_signers_generate_db_auth_token"
  ];

  disabledTestPaths = [
    # Test requires network access
    "tests/test_version.py"
    "tests/test_basic_s3.py"
    "tests/test_batch.py"
    "tests/test_dynamodb.py"
    "tests/test_ec2.py"
    "tests/test_lambda.py"
    "tests/test_monitor.py"
    "tests/test_patches.py"
    "tests/test_sns.py"
    "tests/test_sqs.py"
    "tests/test_waiter.py"
  ];

  disabledTestMarks = [
    # Exclude localonly tests (incompatible with moto mocks)
    "localonly"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Python client for amazon services";
    homepage = "https://github.com/aio-libs/aiobotocore";
    changelog = "https://github.com/aio-libs/aiobotocore/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ teh ];
  };
}
