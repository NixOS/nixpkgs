{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, anyio
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
  version = "0.11.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "anthropics";
    repo = "anthropic-sdk-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-1g3Bbij9HbMK+JJASe+VTBXx5jCQheXLrcnAD0qMs8g=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    anyio
    distro
    httpx
    sniffio
    pydantic
    tokenizers
    typing-extensions
  ];

  passthru.optional-dependencies = {
    vertex = [ google-auth ];
  };

  nativeCheckInputs = [
    dirty-equals
    pytest-asyncio
    pytestCheckHook
    respx
  ];

  disabledTestPaths = [
    # require network access
    "tests/api_resources"
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
