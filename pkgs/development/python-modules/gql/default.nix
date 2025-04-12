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
  mock,
  parse,
  pytest-asyncio,
  pytest-console-scripts,
  pytestCheckHook,
  pythonOlder,
  requests,
  requests-toolbelt,
  setuptools,
  urllib3,
  vcrpy,
  websockets,
  yarl,
}:

buildPythonPackage rec {
  pname = "gql";
  version = "3.5.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "graphql-python";
    repo = "gql";
    rev = "refs/tags/v${version}";
    hash = "sha256-jm0X+X8gQyQYn03gT14bdr79+Wd5KL9ryvrU/0VUtEU=";
  };

  postPatch = ''
    substituteInPlace setup.py --replace \
      "websockets>=10,<11;python_version>'3.6'" \
      "websockets>=10,<12;python_version>'3.6'"
  '';

  build-system = [ setuptools ];

  dependencies = [
    anyio
    backoff
    graphql-core
    yarl
  ];

  nativeCheckInputs = [
    aiofiles
    mock
    parse
    pytest-asyncio
    pytest-console-scripts
    pytestCheckHook
    vcrpy
  ] ++ optional-dependencies.all;

  optional-dependencies = {
    all = [
      aiohttp
      botocore
      httpx
      requests
      requests-toolbelt
      urllib3
      websockets
    ];
    aiohttp = [ aiohttp ];
    httpx = [ httpx ];
    requests = [
      requests
      requests-toolbelt
      urllib3
    ];
    websockets = [ websockets ];
    botocore = [ botocore ];
  };

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  pytestFlagsArray = [
    "--asyncio-mode=auto"
    "-m 'not online'"
  ];

  disabledTests = [
    # Tests requires network access
    "test_async_client_validation_fetch_schema_from_server_valid_query"
    "test_execute_result_error"
    "test_get_introspection_query_ast"
    "test_header_query"
    "test_hero_name_query"
    "test_http_transport"
    "test_named_query"
    "test_query_with_variable"
  ];

  disabledTestPaths = [
    # Exclude linter tests
    "gql-checker/tests/test_flake8_linter.py"
    "gql-checker/tests/test_pylama_linter.py"
  ];

  pythonImportsCheck = [ "gql" ];

  meta = with lib; {
    description = "GraphQL client in Python";
    homepage = "https://github.com/graphql-python/gql";
    changelog = "https://github.com/graphql-python/gql/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "gql-cli";
  };
}
