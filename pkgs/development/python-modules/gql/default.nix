{
  lib,
  aiofiles,
  aiohttp,
  anyio,
  backoff,
  botocore,
  buildPythonPackage,
  fetchFromGitHub,
  graphql-core,
  httpx,
  parse,
  pytest-asyncio_0,
  pytest-console-scripts,
  pytestCheckHook,
  requests,
  requests-toolbelt,
  setuptools,
  vcrpy,
  websockets,
  yarl,
}:

buildPythonPackage rec {
  pname = "gql";
  version = "4.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "graphql-python";
    repo = "gql";
    tag = "v${version}";
    hash = "sha256-bPdlFN6MRT6G9Mw2g2BBfsOGpQmT7pbRatpqa7CImSs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    anyio
    backoff
    graphql-core
    yarl
  ];

  nativeCheckInputs = [
    parse
    pytest-asyncio_0
    pytest-console-scripts
    pytestCheckHook
    vcrpy
  ]
  ++ optional-dependencies.all;

  optional-dependencies = {
    all = [
      aiofiles
      aiohttp
      botocore
      httpx
      requests
      requests-toolbelt
      websockets
    ];
    aiofiles = [ aiofiles ];
    aiohttp = [ aiohttp ];
    httpx = [ httpx ];
    requests = [
      requests
      requests-toolbelt
    ];
    websockets = [ websockets ];
    botocore = [ botocore ];
  };

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  disabledTestMarks = [
    "online"
  ];

  pythonImportsCheck = [ "gql" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "GraphQL client in Python";
    homepage = "https://github.com/graphql-python/gql";
    changelog = "https://github.com/graphql-python/gql/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "gql-cli";
  };
}
