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
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
  requests,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pydrawise";
  version = "2026.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dknowles2";
    repo = "pydrawise";
    tag = finalAttrs.version;
    hash = "sha256-1Ips30vk+utFL2IOaXZ3ApbaCxscY41h2pBOenB5AWM=";
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
    pydantic
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
