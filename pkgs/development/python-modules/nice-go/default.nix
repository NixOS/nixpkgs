{
  buildPythonPackage,
  fetchFromGitHub,
  aiobotocore,
  aiohttp,
  lib,
  poetry-core,
  pycognito,
  pytest-aiohttp,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  syrupy,
  tenacity,
  yarl,
}:

buildPythonPackage rec {
  pname = "nice-go";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "IceBotYT";
    repo = "nice-go";
    tag = version;
    hash = "sha256-u4AhFYhRYwcAGUrXhUgP+SgR0aoric864qSyWhc7Gmo=";
  };

  build-system = [ poetry-core ];

  pythonRelaxDeps = [ "tenacity" ];

  dependencies = [
    aiobotocore
    aiohttp
    pycognito
    tenacity
    yarl
  ];

  pythonImportsCheck = [ "nice_go" ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ];

  meta = {
    changelog = "https://github.com/IceBotYT/nice-go/blob/${src.tag}/CHANGELOG.md";
    description = "Control various Nice access control products";
    homepage = "https://github.com/IceBotYT/nice-go";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
