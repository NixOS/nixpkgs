{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  aiobotocore,
  aiohttp,
  fsspec,

  # tests
  flask,
  flask-cors,
  moto,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "s3fs";
  version = "2026.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fsspec";
    repo = "s3fs";
    tag = version;
    hash = "sha256-Mob7h8dvwRAPPQ854oCzfoV7ir4UBI9P+ZVlmctjDkc=";
  };

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = [ "fsspec" ];

  dependencies = [
    aiobotocore
    fsspec
    aiohttp
  ];

  optional-dependencies = {
    awscli = aiobotocore.optional-dependencies.awscli;
    boto3 = aiobotocore.optional-dependencies.boto3;
  };

  pythonImportsCheck = [ "s3fs" ];

  nativeCheckInputs = [
    flask
    flask-cors
    moto
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # require network access
    "test_async_close"
    "test_session_close"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Pythonic file interface for S3";
    homepage = "https://github.com/fsspec/s3fs";
    changelog = "https://github.com/fsspec/s3fs/blob/${src.tag}/docs/source/changelog.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ teh ];
  };
}
