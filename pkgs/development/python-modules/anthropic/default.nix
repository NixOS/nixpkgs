{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, anyio
, distro
, dirty-equals
, httpx
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
  version = "0.7.8";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "anthropics";
    repo = "anthropic-sdk-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-1mpNwZJbYdKVmUeUM+PBL6vPhwe8tr2SnAP/t/MMKpI=";
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

  nativeCheckInputs = [
    dirty-equals
    pytest-asyncio
    pytestCheckHook
    respx
  ];

  disabledTests = [
    "api_resources"
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
