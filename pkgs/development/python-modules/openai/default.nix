{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,
  pythonOlder,

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

  numpy,
  pandas,
  pandas-stubs,
  websockets,

  # check deps
  pytestCheckHook,
  dirty-equals,
  inline-snapshot,
  nest-asyncio,
  pytest-asyncio,
  pytest-mock,
  respx,
}:

buildPythonPackage rec {
  pname = "openai";
  version = "1.65.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "openai";
    repo = "openai-python";
    tag = "v${version}";
    hash = "sha256-RsLJBuus/84B9NzX6PwYOfmbH7M1eKiXqbyoNlpiEzg=";
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
    tqdm
    typing-extensions
  ] ++ optional-dependencies.realtime;

  optional-dependencies = {
    datalib = [
      numpy
      pandas
      pandas-stubs
    ];
    realtime = [
      websockets
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
    respx
  ];

  pytestFlagsArray = [
    "-W"
    "ignore::DeprecationWarning"
  ];

  disabledTests =
    [
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

  meta = with lib; {
    description = "Python client library for the OpenAI API";
    homepage = "https://github.com/openai/openai-python";
    changelog = "https://github.com/openai/openai-python/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ malo ];
    mainProgram = "openai";
  };
}
