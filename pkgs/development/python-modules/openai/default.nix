{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,

  # build-system
  hatchling,

  # dependencies
  anyio,
  httpx,
  httpx2,
  jiter,
  pydantic,
  sniffio,
  typing-extensions,

  # optional-dependencies (aiohttp)
  aiohttp,

  # optional-dependencies (bedrock)
  botocore,
  urllib3,

  # optional-dependencies (datalib)
  numpy,
  pandas,

  # optional-dependencies (realtime)
  websockets,

  # optional-dependencies (voice-helpers)
  sounddevice,

  # check deps
  pytestCheckHook,
  inline-snapshot,
  pytest-asyncio,
  pytest-xdist,
  rich,

  # optional-dependencies toggle
  withAiohttp ? false,
  withDatalib ? false,
  withRealtime ? false,
  withVoiceHelpers ? false,
}:

buildPythonPackage (finalAttrs: {
  pname = "openai";
  version = "3.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openai";
    repo = "openai-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mHeEVOYU3rku2Cmd/aOzqvduvod97txCtnoLBVsz5EA=";
  };

  postPatch = ''substituteInPlace pyproject.toml --replace-fail "hatchling==1.27.0" "hatchling"'';

  # scripts/build and scripts/test-pydantic-v1 are executed by tests/test_uv_workflows.py
  preCheck = ''
    patchShebangs scripts
  '';

  build-system = [
    hatchling
  ];

  dependencies = [
    anyio
    httpx2
    jiter
    pydantic
    sniffio
    typing-extensions
  ]
  ++ lib.optionals withAiohttp finalAttrs.passthru.optional-dependencies.aiohttp
  ++ lib.optionals withDatalib finalAttrs.passthru.optional-dependencies.datalib
  ++ lib.optionals withRealtime finalAttrs.passthru.optional-dependencies.realtime
  ++ lib.optionals withVoiceHelpers finalAttrs.passthru.optional-dependencies.voice-helpers;

  optional-dependencies = {
    aiohttp = [
      aiohttp
    ];
    bedrock = [
      botocore
      urllib3
    ];
    datalib = [
      numpy
      pandas
    ];
    realtime = [
      websockets
    ];
    voice-helpers = [
      numpy
      sounddevice
    ];
  };

  pythonImportsCheck = [ "openai" ];

  nativeCheckInputs = [
    pytestCheckHook
    inline-snapshot
    pytest-asyncio
    pytest-xdist
    rich
    httpx
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  disabledTestPaths = [
    # Test makes network requests
    "tests/api_resources"
    # E   TypeError: Unexpected type for 'content', <class 'inline_snapshot._external.external'>
    # This seems to be due to `inline-snapshot` being disabled when `pytest-xdist` is used.
    "tests/lib/chat/test_completions_streaming.py"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python client library for the OpenAI API";
    homepage = "https://github.com/openai/openai-python";
    changelog = "https://github.com/openai/openai-python/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.malo ];
  };
})
