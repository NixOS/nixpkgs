{
  lib,
  authlib,
  buildPythonPackage,
  fastapi,
  fetchFromGitHub,
  httpx,
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
  version = "0.6.4";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "MartinHjelmare";
    repo = "aiohomeconnect";
    rev = "refs/tags/v${version}";
    hash = "sha256-vy1pcLNRi5C0okdWMYWOHanEiN0Nl4WqZT1cC6UktCU=";
  };

  pythonRelaxDeps = [ "httpx" ];

  build-system = [ poetry-core ];

  dependencies = [
    httpx
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
