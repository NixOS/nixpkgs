{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-fancy-pypi-readme,
  hatchling,
  pythonAtLeast,

  # dependencies
  anyio,
  distro,
  httpx,
  jiter,
  pydantic,
  sniffio,
  tokenizers,
  typing-extensions,

  # optional dependencies
  google-auth,

  # test
  dirty-equals,
  nest-asyncio,
  pytest-asyncio,
  pytestCheckHook,
  respx,
}:

buildPythonPackage rec {
  pname = "anthropic";
  version = "0.49.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "anthropics";
    repo = "anthropic-sdk-python";
    tag = "v${version}";
    hash = "sha256-vbK8rqCekWbgLAU7YlHUhfV+wB7Q3Rpx0OUYvq3WYWw=";
  };

  build-system = [
    hatchling
    hatch-fancy-pypi-readme
  ];

  dependencies = [
    anyio
    distro
    httpx
    jiter
    pydantic
    sniffio
    tokenizers
    typing-extensions
  ];

  optional-dependencies = {
    vertex = [ google-auth ];
  };

  nativeCheckInputs = [
    dirty-equals
    nest-asyncio
    pytest-asyncio
    pytestCheckHook
    respx
  ];

  pythonImportsCheck = [ "anthropic" ];

  disabledTests =
    [
      # Test require network access
      "test_copy_build_request"
    ]
    ++ lib.optionals (pythonAtLeast "3.13") [
      # Fails on RuntimeWarning: coroutine method 'aclose' of 'AsyncStream._iter_events' was never awaited
      "test_multi_byte_character_multiple_chunks[async]"
    ];

  disabledTestPaths = [
    # Test require network access
    "tests/api_resources"
    "tests/lib/test_bedrock.py"
  ];

  pytestFlagsArray = [
    "-W"
    "ignore::DeprecationWarning"
  ];

  meta = {
    description = "Anthropic's safety-first language model APIs";
    homepage = "https://github.com/anthropics/anthropic-sdk-python";
    changelog = "https://github.com/anthropics/anthropic-sdk-python/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.natsukium
      lib.maintainers.sarahec
    ];
  };
}
