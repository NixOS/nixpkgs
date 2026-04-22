{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  graphql-core,
  hatchling,
  httpx,
  opentelemetry-api,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  python-multipart,
  starlette,
  syrupy,
  typing-extensions,
  werkzeug,
}:

buildPythonPackage (finalAttrs: {
  pname = "ariadne";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mirumee";
    repo = "ariadne";
    tag = finalAttrs.version;
    hash = "sha256-V5/4kLdb3Apnnq91HQ3eApl1R2+pqeWhWi5Y0ULqJrI=";
  };

  build-system = [ hatchling ];

  dependencies = [
    graphql-core
    starlette
    typing-extensions
  ];

  nativeCheckInputs = [
    freezegun
    httpx
    opentelemetry-api
    pytest-asyncio
    pytest-mock
    pytestCheckHook
    python-multipart
    syrupy
    werkzeug
  ];

  pythonImportsCheck = [ "ariadne" ];

  disabledTestPaths = [
    # missing graphql-sync-dataloader test dep
    "tests/test_dataloaders.py"
    "tests/wsgi/test_configuration.py"
  ];

  meta = {
    description = "Python library for implementing GraphQL servers using schema-first approach";
    homepage = "https://ariadnegraphql.org";
    changelog = "https://github.com/mirumee/ariadne/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ samuela ];
  };
})
