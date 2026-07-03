{
  lib,
  aiohttp,
  aioresponses,
  apischema,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  gql,
  graphql-core,
  pytest-asyncio,
  pytestCheckHook,
  requests,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "pydrawise";
  version = "2026.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dknowles2";
    repo = "pydrawise";
    tag = finalAttrs.version;
    hash = "sha256-j1ovfQGi5DpDPWVwUA0mDIDztjVKkB7wFuK2HunXc3c=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    aiohttp
    apischema
    gql
    graphql-core
    requests
  ];

  nativeCheckInputs = [
    aioresponses
    freezegun
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pydrawise" ];

  meta = {
    description = "Library for interacting with Hydrawise sprinkler controllers through the GraphQL API";
    homepage = "https://github.com/dknowles2/pydrawise";
    changelog = "https://github.com/dknowles2/pydrawise/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
