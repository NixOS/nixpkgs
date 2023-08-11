{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, anyio
, distro
, httpx
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
  version = "0.3.8";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "anthropics";
    repo = "anthropic-sdk-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-rNLKIZKX9AI0IKGicozllh+XGU4Ll91EfRaAfJYJtJE=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    anyio
    distro
    httpx
    pydantic
    tokenizers
    typing-extensions
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    respx
  ];

  pythonImportsCheck = [
    "anthropic"
  ];

  disabledTests = [
    "api_resources"
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
    broken = lib.versionAtLeast pydantic.version "2";
  };
}
