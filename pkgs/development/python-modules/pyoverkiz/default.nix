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

buildPythonPackage (finalAttrs: {
  pname = "pyoverkiz";
  version = "1.20.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iMicknl";
    repo = "python-overkiz-api";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PaJ4AC0N82iGTsgP620uI6Iw9l0aHrR7UutWLYxrOYE=";
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
    changelog = "https://github.com/iMicknl/python-overkiz-api/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
