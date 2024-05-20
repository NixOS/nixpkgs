{  lib,
  anyio,
  buildPythonPackage,
  cached-property,
  dirty-equals,
  distro,
  fetchFromGitHub,
  hatch-fancy-pypi-readme,
  hatchling,
  httpx,
  numpy,
  pandas,
  pandas-stubs,
  pydantic,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  respx,
  sniffio,
  tqdm,
  typing-extensions,
}:

# This package is based on openai-python, hence the same build config
buildPythonPackage rec {
  pname = "groq";
  version = "0.6.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "groq";
    repo = "groq-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-Ee7hqEHeKV4iHktNASKBkPjiLM3EvKzr5nKQ9/AGXiU=";
  };

  build-system = [
    hatchling
    hatch-fancy-pypi-readme
  ];

  dependencies = [
    httpx
    pydantic
    typing-extensions
    anyio
    distro
    sniffio
    tqdm
  ] ++ lib.optionals (pythonOlder "3.8") [ cached-property ];

  passthru.optional-dependencies = {
    datalib = [
      numpy
      pandas
      pandas-stubs
    ];
  };

  pythonImportsCheck = [ "groq" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-mock
    respx
    dirty-equals
  ];

  pytestFlagsArray = [
    "-W"
    "ignore::DeprecationWarning"
  ];

  disabledTests = [
    # Tests make network requests
    "test_streaming_response"
    "test_copy_build_request"

    # Test fails with pytest>=8
    "test_basic_attribute_access_works"
  ];

  disabledTestPaths = [
    # Test makes network requests
    "tests/api_resources"
  ];

  meta = {
    description = "Python client library for the Groq API";
    homepage = "https://github.com/groq/groq-python";
    changelog = "https://github.com/groq/groq-python/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [];
    mainProgram = "groq";
  };
}
