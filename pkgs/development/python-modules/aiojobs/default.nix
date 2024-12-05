{
  lib,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  pytest-aiohttp,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aiojobs";
  version = "1.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "aiojobs";
    rev = "refs/tags/v${version}";
    hash = "sha256-FNc71YyAjtR+hd0UOqFAy6XW0PwHSlM76C3ecPM5vsU=";
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
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "aiojobs" ];

  disabledTests = [
    # RuntimeWarning: coroutine 'Scheduler._wait_failed' was never awaited
    "test_scheduler_must_be_created_within_running_loop"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Jobs scheduler for managing background task (asyncio)";
    homepage = "https://github.com/aio-libs/aiojobs";
    changelog = "https://github.com/aio-libs/aiojobs/blob/v${version}/CHANGES.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ cmcdragonkai ];
  };
}
