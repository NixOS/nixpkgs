{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  hatchling,
  pyprojectVersionPatchHook,
  click,
  graphql-core,
  toml,
  httpx,
  pydantic,
  ruff,
  pytestCheckHook,
  pytest-asyncio,
  pytest-httpx,
  pytest-mock,
  ariadne,
  freezegun,
  requests-toolbelt,
  opentelemetry-api,
  websockets,
}:
buildPythonPackage (finalAttrs: {
  pname = "ariadne-codegen";
  version = "0.19.0";
  pyproject = true;
  src = fetchFromGitHub {
    owner = "mirumee";
    repo = "ariadne-codegen";
    tag = finalAttrs.version;
    hash = "sha256-IAIZD9kquEOKKfpoaGWwFlCYD1MalTcYhNUIQpMofZI=";
  };

  nativeBuildInputs = [
    pyprojectVersionPatchHook
  ];

  dependencies = [
    click
    graphql-core
    toml
    httpx
    pydantic
    ruff
  ];

  pythonRelaxDeps = [ "ruff" ];

  build-system = [ hatchling ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-httpx
    pytest-mock
    ariadne
    freezegun
    requests-toolbelt
    opentelemetry-api
    websockets
  ];

  disabledTests = [
    # Expected output was generated with graphql-core 3.2.11 (per uv.lock);
    # nixpkgs' older graphql-core 3.2.x omits some directive locations
    "test_main_generates_correct_schema_file"
  ];

  pythonImportCheck = true;
  meta = {
    description = "Generate fully typed GraphQL client from schema, queries and mutations";
    homepage = "https://github.com/mirumee/ariadne-codegen";
    changelog = "https://github.com/mirumee/ariadne-codegen/releases/tag/${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ mhdask ];
  };
})
