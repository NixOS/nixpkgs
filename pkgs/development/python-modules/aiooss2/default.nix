{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  oss2,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  requests,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "aiooss2";
  version = "0.2.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "karajan1001";
    repo = "aiooss2";
    tag = version;
    hash = "sha256-6tkJG6Jjvo2OaN9cRbs/7ApcrKiZ5tGSPUfugAx7iJU=";
  };

  pythonRelaxDeps = [
    "aiohttp"
    "oss2"
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    aiohttp
    oss2
  ];

  nativeCheckInputs = [
    pytest-mock
    pytest-asyncio
    pytestCheckHook
    requests
  ];

  pythonImportsCheck = [ "aiooss2" ];

  disabledTestPaths = [
    # Tests require network access
    "tests/func/test_bucket.py"
    "tests/func/test_object.py"
    "tests/func/test_resumable.py"
    "tests/unit/test_adapter.py"
  ];

  meta = {
    description = "Library for aliyun OSS (Object Storage Service)";
    homepage = "https://github.com/karajan1001/aiooss2";
    changelog = "https://github.com/karajan1001/aiooss2/blob/${version}/CHANGES.txt";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
