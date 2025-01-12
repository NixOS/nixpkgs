{
  lib,
  authlib,
  buildPythonPackage,
  fastapi,
  fetchFromGitHub,
  httpx,
  httpx-sse,
  mashumaro,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-httpx,
  pytestCheckHook,
  pythonOlder,
  typer,
  uvicorn,
}:

buildPythonPackage rec {
  pname = "aiohomeconnect";
  version = "0.9.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "MartinHjelmare";
    repo = "aiohomeconnect";
    tag = "v${version}";
    hash = "sha256-SHrhlchjyUPhf/LnIHB/b90aglboVArcQ/YTOw1vbII=";
  };

  pythonRelaxDeps = [ "httpx" ];

  build-system = [ poetry-core ];

  dependencies = [
    httpx
    httpx-sse
    mashumaro
  ];

  optional-dependencies = {
    cli = [
      authlib
      fastapi
      typer
      uvicorn
    ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytest-httpx
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "aiohomeconnect" ];

  meta = {
    description = "An asyncio client for the Home Connect API";
    homepage = "https://github.com/MartinHjelmare/aiohomeconnect";
    changelog = "https://github.com/MartinHjelmare/aiohomeconnect/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
