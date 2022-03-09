{ lib
, aiofiles
, aiohttp
, botocore
, buildPythonPackage
, fetchFromGitHub
, graphql-core
, mock
, parse
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, requests
, requests-toolbelt
, urllib3
, vcrpy
, websockets
, yarl
}:

buildPythonPackage rec {
  pname = "gql";
  version = "3.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "graphql-python";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-c2OVBOIwQlwyqET8Q22O65VtWduVzQjYOhkE8GpD6LQ=";
  };

  propagatedBuildInputs = [
    aiohttp
    botocore
    graphql-core
    requests
    requests-toolbelt
    urllib3
    websockets
    yarl
  ];

  checkInputs = [
    aiofiles
    mock
    parse
    pytest-asyncio
    pytestCheckHook
    vcrpy
  ];

  disabledTests = [
    # Tests requires network access
    "test_execute_result_error"
    "test_http_transport"
  ];

  disabledTestPaths = [
    # Exclude linter tests
    "gql-checker/tests/test_flake8_linter.py"
    "gql-checker/tests/test_pylama_linter.py"
  ];

  pythonImportsCheck = [
    "gql"
  ];

  meta = with lib; {
    description = "GraphQL client in Python";
    homepage = "https://github.com/graphql-python/gql";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
