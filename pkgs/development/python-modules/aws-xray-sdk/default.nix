{
  lib,
  aiohttp,
  botocore,
  bottle,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  httpx,
  importlib-metadata,
  jsonpickle,
  pymysql,
  pytest-asyncio_0,
  pynamodb,
  pytestCheckHook,
  pythonOlder,
  requests,
  setuptools,
  sqlalchemy,
  webtest,
  wrapt,
}:

buildPythonPackage rec {
  pname = "aws-xray-sdk";
  version = "2.14.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-xray-sdk-python";
    tag = version;
    hash = "sha256-rWP0yQ+Ril0UByOCWJKcL3mD7TvzK8Ddq9JlFIRBFU4=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    botocore
    jsonpickle
    requests
    wrapt
  ]
  ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  nativeCheckInputs = [
    aiohttp
    bottle
    django
    httpx
    pymysql
    pynamodb
    pytest-asyncio_0
    pytestCheckHook
    sqlalchemy
    webtest
  ];

  disabledTestPaths = [
    # This reduces the amount of dependencies
    "tests/ext/"
    # We don't care about benchmarks
    "tests/test_local_sampling_benchmark.py"
    "tests/test_patcher.py"
    # async def functions are not natively supported.
    "tests/test_async_recorder.py"
  ];

  pythonImportsCheck = [ "aws_xray_sdk" ];

  meta = with lib; {
    description = "AWS X-Ray SDK for the Python programming language";
    homepage = "https://github.com/aws/aws-xray-sdk-python";
    changelog = "https://github.com/aws/aws-xray-sdk-python/blob/${version}/CHANGELOG.rst";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
