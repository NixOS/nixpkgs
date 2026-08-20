{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,
  hatch-fancy-pypi-readme,

  # dependencies
  anyio,
  distro,
  httpx,
  jiter,
  pydantic,
  sniffio,
  tqdm,
  typing-extensions,

  # optional-dependencies (aiohttp)
  aiohttp,
  httpx-aiohttp,

  # optional-dependencies (bedock)
  botocore,

  # optional-dependencies (datalib)
  numpy,
  pandas,
  pandas-stubs,

  # optional-dependencies (httpx2)
  httpx2,

  # optional-dependencies (realtime)
  websockets,

  # optional-dependencies (voice-helpers)
  sounddevice,

  # check deps
  pytestCheckHook,
  dirty-equals,
  inline-snapshot,
  jsonschema,
  pytest-asyncio,
  pytest-mock,
  pytest-xdist,
  respx,

  # optional-dependencies toggle
  withAiohttp ? false,
  withDatalib ? false,
  withRealtime ? false,
  withVoiceHelpers ? false,
}:

buildPythonPackage (finalAttrs: {
  pname = "openai";
  version = "2.53.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openai";
    repo = "openai-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XwiSIKjYD07zhx8uIO8wsPWdAASBCJ5KqFUgdk+uaUU=";
  };

  postPatch = ''substituteInPlace pyproject.toml --replace-fail "hatchling==1.26.3" "hatchling"'';

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
    tqdm
    typing-extensions
  ]
  ++ lib.optionals withAiohttp finalAttrs.passthru.optional-dependencies.aiohttp
  ++ lib.optionals withDatalib finalAttrs.passthru.optional-dependencies.datalib
  ++ lib.optionals withRealtime finalAttrs.passthru.optional-dependencies.realtime
  ++ lib.optionals withVoiceHelpers finalAttrs.passthru.optional-dependencies.voice-helpers;

  optional-dependencies = {
    aiohttp = [
      aiohttp
      httpx-aiohttp
    ];
    bedrock = [
      botocore
    ];
    datalib = [
      numpy
      pandas
      pandas-stubs
    ];
    httpx2 = [
      anyio
      httpx
      httpx2
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
    dirty-equals
    inline-snapshot
    jsonschema
    pytest-asyncio
    pytest-mock
    pytest-xdist
    respx
  ]
  # including pandas-stubs would cause infinite recursion
  ++ lib.concatAttrValues (lib.removeAttrs finalAttrs.passthru.optional-dependencies [ "datalib" ]);

  disabledTestPaths = [
    # Test makes network requests
    "tests/api_resources"
    # E   TypeError: Unexpected type for 'content', <class 'inline_snapshot._external.external'>
    # This seems to be due to `inline-snapshot` being disabled when `pytest-xdist` is used.
    "tests/lib/chat/test_completions_streaming.py"
  ];

  meta = {
    description = "Python client library for the OpenAI API";
    homepage = "https://github.com/openai/openai-python";
    changelog = "https://github.com/openai/openai-python/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.malo ];
  };
})
