{ lib
, anyio
, buildPythonPackage
, dirty-equals
, distro
, fetchFromGitHub
, hatchling
, httpx
, numpy
, pandas
, pandas-stubs
, pydantic
, pytest-asyncio
, pytest-mock
, pytestCheckHook
, pythonOlder
, respx
, sniffio
, tqdm
, typing-extensions
}:

buildPythonPackage rec {
  pname = "openai";
  version = "1.14.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "openai";
    repo = "openai-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-d2alP0jcpExYezSrxhT/2Dr7hylJBqNfvrXh3+MFa34=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    anyio
    distro
    httpx
    pydantic
    sniffio
    tqdm
    typing-extensions
  ];

  passthru.optional-dependencies = {
    datalib = [
      numpy
      pandas
      pandas-stubs
    ];
  };

  nativeCheckInputs = [
    dirty-equals
    pytest-asyncio
    pytest-mock
    pytestCheckHook
    respx
  ];

  pythonImportsCheck = [
    "openai"
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

  meta = with lib; {
    description = "Python client library for the OpenAI API";
    homepage = "https://github.com/openai/openai-python";
    changelog = "https://github.com/openai/openai-python/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ malo ];
    mainProgram = "openai";
  };
}
