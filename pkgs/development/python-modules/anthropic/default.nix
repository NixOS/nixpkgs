{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
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

  patches = [
    (fetchpatch {
      name = "support-pytest-asyncio-0.21.0.patch";
      url = "https://github.com/anthropics/anthropic-sdk-python/commit/1e199aa9b38970c5b5b4492907494ac653a7f756.patch";
      hash = "sha256-f9KldnvXuRKVgT7Xb/xdhInKOeXvi4g5OxVRD0PMhgQ=";
    })
  ];

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
    broken = lib.versionAtLeast pydantic.version "2";
  };
}
