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
  pythonOlder,
  requests,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pydrawise";
  version = "2025.1.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "dknowles2";
    repo = "pydrawise";
    tag = version;
    hash = "sha256-LF7y8d2OqEJIy+FTj8J/OOQkgkaqYNv5oD8jLUwEPlE=";
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

  meta = with lib; {
    description = "Library for interacting with Hydrawise sprinkler controllers through the GraphQL API";
    homepage = "https://github.com/dknowles2/pydrawise";
    changelog = "https://github.com/dknowles2/pydrawise/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
