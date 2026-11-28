{
  lib,
  aiofiles,
  aiohttp,
  anyio,
  backoff,
  botocore,
  buildPythonPackage,
  cacert,
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
    cacert
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

  disabledTests = [
    # broken in 4.0.0 on nixpkgs master, re-evaluate after upgrade
    "test_get_introspection_query_ast"
    "test_node_tree_with_loc"
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
