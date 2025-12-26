{
  lib,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-aiohttp,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aiojobs";
  version = "1.4.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "aiojobs";
    tag = "v${version}";
    hash = "sha256-MgGUmDG0b0V/k+mCeiVRnBxa+ChK3URnGv6P8QP7RzQ=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.11") [ async-timeout ];

  optional-dependencies = {
    aiohttp = [ aiohttp ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-aiohttp
    pytest-cov-stub
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "aiojobs" ];

  disabledTests = [
    # RuntimeWarning: coroutine 'Scheduler._wait_failed' was never awaited
    "test_scheduler_must_be_created_within_running_loop"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Jobs scheduler for managing background task (asyncio)";
    homepage = "https://github.com/aio-libs/aiojobs";
    changelog = "https://github.com/aio-libs/aiojobs/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ cmcdragonkai ];
  };
}
