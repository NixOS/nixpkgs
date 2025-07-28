{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

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

  # `httpx_aiohttp` not currently in `nixpkgs`
  # optional-dependencies (aiohttp)
  # aiohttp,
  # httpx_aiohttp,

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
  withRealtime ? true,
  withVoiceHelpers ? true,
}:

buildPythonPackage rec {
  pname = "openai";
  version = "1.97.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openai";
    repo = "openai-python";
    tag = "v${version}";
    hash = "sha256-q+GUEHducm71Zqh7ZfRF217awFKQIsOSEWoe04M3DFM=";
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
  ++ lib.optionals withRealtime optional-dependencies.realtime
  ++ lib.optionals withVoiceHelpers optional-dependencies.voice-helpers;

  optional-dependencies = {
    # `httpx_aiohttp` not currently in `nixpkgs`
    # aiohttp = [
    #   aiohttp
    #   httpx_aiohttp
    # ];
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

  pytestFlags = [
    "-Wignore::DeprecationWarning"
  ];

  disabledTests = [
    # Tests make network requests
    "test_copy_build_request"
    "test_basic_attribute_access_works"
  ]
  ++ lib.optionals (pythonAtLeast "3.13") [
    # RuntimeWarning: coroutine method 'aclose' of 'AsyncStream._iter_events' was never awaited
    "test_multi_byte_character_multiple_chunks"
  ];

  disabledTestPaths = [
    # Test makes network requests
    "tests/api_resources"
  ];

  meta = {
    description = "Python client library for the OpenAI API";
    homepage = "https://github.com/openai/openai-python";
    changelog = "https://github.com/openai/openai-python/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.malo ];
    mainProgram = "openai";
  };
}
