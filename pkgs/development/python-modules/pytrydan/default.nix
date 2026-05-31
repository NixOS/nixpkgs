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

buildPythonPackage rec {
  pname = "pytrydan";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dgomes";
    repo = "pytrydan";
    tag = "v${version}";
    hash = "sha256-ivLNP5lconJ0G8MuY8xgcJ9MTx91yUjeY1NA4U7OwMo=";
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
    changelog = "https://github.com/dgomes/pytrydan/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "pytrydan";
  };
}
