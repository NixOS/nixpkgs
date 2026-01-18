{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  poetry-core,
  fetchpatch,
}:

buildPythonPackage rec {
  pname = "aiorwlock";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "aiorwlock";
    tag = "v${version}";
    hash = "sha256-QwjwuXjaxE1Y+Jzn8hJXY4wKltAT8mdOM7jJ9MF+DhA=";
  };

  build-system = [ poetry-core ];

  patches = [
    # Fix cross-event-loop race condition in lock acquisition
    # https://github.com/aio-libs/aiorwlock/pull/503
    (fetchpatch {
      url = "https://github.com/aio-libs/aiorwlock/commit/05608d401e4a68c69c6b9f421dd20535a9dbe523.patch?full_index=1";
      hash = "sha256-97c6Li6nq7ViNvUIdPL8f/ATOSsmiAMaJeBFj+jPJcM=";
    })
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiorwlock" ];

  meta = {
    description = "Read write lock for asyncio";
    homepage = "https://github.com/aio-libs/aiorwlock";
    changelog = "https://github.com/aio-libs/aiorwlock/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ billhuang ];
  };
}
