{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  aiohttp,
  aioitertools,
  botocore,
  python-dateutil,
  jmespath,
  multidict,
  urllib3,
  wrapt,
  dill,
  moto,
  pytest-asyncio,
  time-machine,
  werkzeug,
  awscli,
  boto3,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "aiobotocore";
  version = "2.22.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "aiobotocore";
    tag = version;
    hash = "sha256-Zzwj0osXqWSCWsuxlpiqpptzjLhFwlqfXqiWMP7CgXg=";
  };

  # Relax version constraints: aiobotocore works with newer botocore versions
  # the pinning used to match some `extras_require` we're not using.
  pythonRelaxDeps = [ "botocore" ];

  build-system = [
    setuptools
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
  };

  nativeCheckInputs = [
    dill
    moto
    pytest-asyncio
    time-machine
    werkzeug
    pytestCheckHook
  ] ++ moto.optional-dependencies.server;

  pythonImportsCheck = [ "aiobotocore" ];

  disabledTestPaths = [
    # Test requires network access
    "tests/test_version.py"
    # Test not compatible with latest moto
    "tests/python3.8/test_eventstreams.py"
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

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Python client for amazon services";
    homepage = "https://github.com/aio-libs/aiobotocore";
    changelog = "https://github.com/aio-libs/aiobotocore/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ teh ];
  };
}
