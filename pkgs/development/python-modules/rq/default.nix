{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,

  # build-system
  hatchling,

  # dependencies
  click,
  redis,

  # tests
  psutil,
  pytestCheckHook,
  valkey,
  sentry-sdk,
}:

buildPythonPackage rec {
  pname = "rq";
  version = "2.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rq";
    repo = "rq";
    tag = "v${version}";
    hash = "sha256-RuqLfPEwdwfJo+mdY4vB3lpyGkbP/GQDfRU+TmUur3s=";
  };

  build-system = [ hatchling ];

  dependencies = [
    click
    redis
  ];

  nativeCheckInputs = [
    psutil
    pytestCheckHook
    sentry-sdk
  ];

  preCheck = ''
    PATH=$out/bin:$PATH
    ${valkey}/bin/redis-server &
  '';

  postCheck = ''
    kill %%
  '';

  __darwinAllowLocalNetworking = true;

  disabledTests = [
    # https://github.com/rq/rq/commit/fd261d5d8fc0fe604fa396ee6b9c9b7a7bb4142f
    "test_clean_large_registry"
  ];

  pythonImportsCheck = [ "rq" ];

  meta = with lib; {
    description = "Library for creating background jobs and processing them";
    homepage = "https://github.com/nvie/rq/";
    changelog = "https://github.com/rq/rq/releases/tag/${src.tag}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ mrmebelman ];
  };
}
