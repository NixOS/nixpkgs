{
  lib,
  anyio,
  buildPythonPackage,
  dirty-equals,
  distro,
  fetchFromGitHub,
  google-auth,
  hatch-fancy-pypi-readme,
  hatchling,
  httpx,
  jiter,
  nest-asyncio,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  respx,
  sniffio,
  tokenizers,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "anthropic";
  version = "0.43.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "anthropics";
    repo = "anthropic-sdk-python";
    tag = "v${version}";
    hash = "sha256-7tDCKFT+j6oRU4EeII4wAM1T5W4qAeg6HbBp3efO81A=";
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
    sniffio
    pydantic
    tokenizers
    typing-extensions
  ];

  optional-dependencies = {
    vertex = [ google-auth ];
  };

  nativeCheckInputs = [
    dirty-equals
    pytest-asyncio
    nest-asyncio
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

  meta = with lib; {
    description = "Anthropic's safety-first language model APIs";
    homepage = "https://github.com/anthropics/anthropic-sdk-python";
    changelog = "https://github.com/anthropics/anthropic-sdk-python/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
