{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  orjson,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  respx,
  rich,
  syrupy,
  tenacity,
  typer,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytrydan";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dgomes";
    repo = "pytrydan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oXnTDwCY2Z/K7YwWNTwbbB0W47bZD+W6uFxZQRF3KgQ=";
  };

  pythonRelaxDeps = [ "tenacity" ];

  build-system = [ poetry-core ];

  dependencies = [
    httpx
    orjson
    rich
    tenacity
    typer
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    respx
    syrupy
  ];

  pythonImportsCheck = [ "pytrydan" ];

  meta = {
    description = "Library to interface with V2C EVSE Trydan";
    homepage = "https://github.com/dgomes/pytrydan";
    changelog = "https://github.com/dgomes/pytrydan/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "pytrydan";
  };
})
