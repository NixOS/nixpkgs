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
  version = "1.2.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "aiojobs";
    rev = "refs/tags/v${version}";
    hash = "sha256-LwFXb/SHP6bbqPg1tqYwE03FKHf4Mv1PPOxnPdESH0I=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/aio-libs/aiojobs/commit/1b88049841397b01f88aee7d92174ac5a15217c1.patch";
      hash = "sha256-b38Ipa29T6bEVsPe04ZO3WCcs6+0fOQDCJM+w8K1bVY=";
    })
  ];

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

  meta = with lib; {
    description = "Jobs scheduler for managing background task (asyncio)";
    homepage = "https://github.com/aio-libs/aiojobs";
    changelog = "https://github.com/aio-libs/aiojobs/blob/v${version}/CHANGES.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ cmcdragonkai ];
  };
}
