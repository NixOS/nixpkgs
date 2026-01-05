{
  lib,
  aiohttp,
  attrs,
  backoff,
  boto3,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pyhumps,
  pytest-asyncio,
  pytestCheckHook,
  warrant-lite,
}:

buildPythonPackage rec {
  pname = "pyoverkiz";
  version = "1.19.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iMicknl";
    repo = "python-overkiz-api";
    tag = "v${version}";
    hash = "sha256-h7PGtcpBcYGlqdi4grbz7KG65zZO3x8Hf/J7n271sDs=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    attrs
    backoff
    boto3
    pyhumps
    warrant-lite
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyoverkiz" ];

  meta = {
    description = "Module to interact with the Somfy TaHoma API or other OverKiz APIs";
    homepage = "https://github.com/iMicknl/python-overkiz-api";
    changelog = "https://github.com/iMicknl/python-overkiz-api/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
