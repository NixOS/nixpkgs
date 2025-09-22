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

  # optional-dependencies (datalib)
  numpy,
  pandas,
  pandas-stubs,

  # optional-dependencies (realtime)
  websockets,

  # optional-dependencies (voice-helpers)
  sounddevice,

  # check deps
  pytestCheckHook,
  dirty-equals,
  inline-snapshot,
  nest-asyncio,
  pytest-asyncio,
  pytest-mock,
  pytest-xdist,
  respx,

  # optional-dependencies toggle
  withAiohttp ? true,
  withDatalib ? false,
  withRealtime ? true,
  withVoiceHelpers ? true,
}:

buildPythonPackage rec {
  pname = "openai";
  version = "1.101.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openai";
    repo = "openai-python";
    tag = "v${version}";
    hash = "sha256-XCstUYM2jiq3PbNiRmLnguzQtvrGk0Ik5K0tk37bq2U=";
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
  ++ lib.optionals withAiohttp optional-dependencies.aiohttp
  ++ lib.optionals withDatalib optional-dependencies.datalib
  ++ lib.optionals withRealtime optional-dependencies.realtime
  ++ lib.optionals withVoiceHelpers optional-dependencies.voice-helpers;

  optional-dependencies = {
    aiohttp = [
      aiohttp
      httpx-aiohttp
    ];
    datalib = [
      numpy
      pandas
      pandas-stubs
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
    nest-asyncio
    pytest-asyncio
    pytest-mock
    pytest-xdist
    respx
  ];

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
    changelog = "https://github.com/openai/openai-python/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.malo ];
    mainProgram = "openai";
  };
}
