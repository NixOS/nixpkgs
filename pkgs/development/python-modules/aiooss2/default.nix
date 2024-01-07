{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, oss2
, pytest-asyncio
, pytest-mock
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, requests
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "aiooss2";
  version = "0.2.8";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "karajan1001";
    repo = "aiooss2";
    rev = "refs/tags/${version}";
    hash = "sha256-PwgbUZAuk2woEmLYDdWF5hTs19DASxxUv3Ga844ai7g=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  pythonRelaxDeps = [
    "aiohttp"
    "oss2"
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    aiohttp
    oss2
  ];

  nativeCheckInputs = [
    pytest-mock
    pytest-asyncio
    pytestCheckHook
    requests
  ];

  pythonImportsCheck = [
    "aiooss2"
  ];

  disabledTestPaths = [
    # Tests require network access
    "tests/func/test_bucket.py"
    "tests/func/test_object.py"
    "tests/func/test_resumable.py"
    "tests/unit/test_adapter.py"
  ];

  meta = with lib; {
    description = "Library for aliyun OSS (Object Storage Service)";
    homepage = "https://github.com/karajan1001/aiooss2";
    changelog = "https://github.com/karajan1001/aiooss2/blob/${version}/CHANGES.txt";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
