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
  pythonOlder,
  warrant-lite,
}:

buildPythonPackage rec {
  pname = "pyoverkiz";
  version = "1.19.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "iMicknl";
    repo = "python-overkiz-api";
    tag = "v${version}";
    hash = "sha256-Iur39lUkHBd0VaP5YB36o04D8aY371BeSZ07iN7A9Wk=";
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

  meta = with lib; {
    description = "Module to interact with the Somfy TaHoma API or other OverKiz APIs";
    homepage = "https://github.com/iMicknl/python-overkiz-api";
    changelog = "https://github.com/iMicknl/python-overkiz-api/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
