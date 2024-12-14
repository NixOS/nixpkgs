{
  lib,
  anyio,
  buildPythonPackage,
  dirty-equals,
  distro,
  fetchFromGitHub,
  google-auth,
  hatch-fancy-pypi-readme,
  hatchling,
  httpx,
  jiter,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  respx,
  sniffio,
  tokenizers,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "anthropic";
  version = "0.39.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "anthropics";
    repo = "anthropic-sdk-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-lpW+waHvwgbhK7EnPZy/XI8gK3a8JjFflPqUFbDN1z8=";
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
    sniffio
    pydantic
    tokenizers
    typing-extensions
  ];

  optional-dependencies = {
    vertex = [ google-auth ];
  };

  nativeCheckInputs = [
    dirty-equals
    pytest-asyncio
    pytestCheckHook
    respx
  ];

  pythonImportsCheck = [ "anthropic" ];

  disabledTests = [
    # Test require network access
    "test_copy_build_request"
  ];

  disabledTestPaths = [
    # Test require network access
    "tests/api_resources"
    "tests/lib/test_bedrock.py"
  ];

  pytestFlagsArray = [
    "-W"
    "ignore::DeprecationWarning"
  ];

  meta = with lib; {
    description = "Anthropic's safety-first language model APIs";
    homepage = "https://github.com/anthropics/anthropic-sdk-python";
    changelog = "https://github.com/anthropics/anthropic-sdk-python/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
