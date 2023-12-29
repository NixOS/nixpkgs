{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, hatchling
# propagated
, httpx
, pydantic
, typing-extensions
, anyio
, distro
, sniffio
, tqdm
# optional
, numpy
, pandas
, pandas-stubs
# tests
, pytestCheckHook
, pytest-asyncio
, pytest-mock
, respx
, dirty-equals
}:

buildPythonPackage rec {
  pname = "openai";
  version = "1.6.0";
  pyproject = true;

  disabled = pythonOlder "3.7.1";

  src = fetchFromGitHub {
    owner = "openai";
    repo = "openai-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-bRnsUpHhi+CAzUQSqMFmVWItn6KIKaXMjggxNixaY6Q=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    httpx
    pydantic
    anyio
    distro
    sniffio
    tqdm
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  passthru.optional-dependencies = {
    datalib = [
      numpy
      pandas
      pandas-stubs
    ];
  };

  pythonImportsCheck = [
    "openai"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-mock
    respx
    dirty-equals
  ];

  OPENAI_API_KEY = "sk-foo";

  disabledTestPaths = [
    # makes network requests
    "tests/test_client.py"
    "tests/api_resources"
  ];

  meta = with lib; {
    description = "Python client library for the OpenAI API";
    homepage = "https://github.com/openai/openai-python";
    changelog = "https://github.com/openai/openai-python/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ malo ];
  };
}
