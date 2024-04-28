{ lib
, buildPythonPackage
, fetchFromGitHub
, hatch-fancy-pypi-readme
, hatchling
, anyio
, boto3
, botocore
, distro
, dirty-equals
, httpx
, google-auth
, sniffio
, pydantic
, pytest-asyncio
, respx
, tokenizers
, typing-extensions
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "anthropic";
  version = "0.25.6";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "anthropics";
    repo = "anthropic-sdk-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-83TufOgu6W9UvoCEUgDiw6gXDAdwyIKEALVF0hjj6wk=";
  };

  build-system = [
    hatch-fancy-pypi-readme
    hatchling
  ];

  dependencies = [
    anyio
    distro
    httpx
    sniffio
    pydantic
    tokenizers
    typing-extensions
  ];

  optional-dependencies = {
    vertex = [ google-auth ];
    bedrock = [
      boto3
      botocore
    ];
  };

  nativeCheckInputs = [
    dirty-equals
    pytest-asyncio
    pytestCheckHook
    respx
  ];

  pytestFlagsArray = [
    "-W ignore::DeprecationWarning"
  ];

  disabledTestPaths = [
    # require network access
    "tests/api_resources"
  ];

  disableTests = [
    # require network access
    "test_copy_build_request"
  ];

  pythonImportsCheck = [
    "anthropic"
  ];

  meta = with lib; {
    description = "Anthropic's safety-first language model APIs";
    homepage = "https://github.com/anthropics/anthropic-sdk-python";
    changelog = "https://github.com/anthropics/anthropic-sdk-python/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
