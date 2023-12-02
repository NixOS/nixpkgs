{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
, setuptools
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

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "--cov=aiojobs/ --cov=tests/ --cov-report term" ""
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.11") [
    async-timeout
  ];

  passthru.optional-dependencies = {
    aiohttp = [
      aiohttp
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-aiohttp
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [
    "aiojobs"
  ];

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
