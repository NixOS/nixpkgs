{
  lib,
  aiohttp,
  buildPythonPackage,
  certifi,
  fetchFromGitHub,
  mock,
  opentelemetry-api,
  opentelemetry-sdk,
  orjson,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-httpserver,
  pytestCheckHook,
  pythonOlder,
  requests,
  respx,
  setuptools,
  trustme,
  urllib3,
}:

buildPythonPackage rec {
  pname = "elastic-transport";
  version = "8.17.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "elastic";
    repo = "elastic-transport-python";
    tag = "v${version}";
    hash = "sha256-ZCzG7a/SWvUDWiIWwzVfj4JG/w7XUa25yKuuR53XCEQ=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [
    urllib3
    certifi
  ];

  nativeCheckInputs = [
    aiohttp
    mock
    opentelemetry-api
    opentelemetry-sdk
    orjson
    pytest-asyncio
    pytest-cov-stub
    pytest-httpserver
    pytestCheckHook
    requests
    respx
    trustme
  ];

  pythonImportsCheck = [ "elastic_transport" ];

  pytestFlagsArray = [
    "-W"
    "ignore::DeprecationWarning"
  ];

  disabledTests = [
    # Tests require network access
    "fingerprint"
    "ssl"
    "test_custom_headers"
    "test_custom_user_agent"
    "test_default_headers"
    "test_head"
    "tls"
    "test_simple_request"
    "test_node"
    "test_debug_logging"
    "test_debug_logging_uncompressed_body"
    "test_debug_logging_no_body"
    "test_httpbin"
    "test_sniffed_nodes_added_to_pool"
    "test_async_transport_httpbin"
  ];

  meta = with lib; {
    description = "Transport classes and utilities shared among Python Elastic client libraries";
    homepage = "https://github.com/elasticsearch/elastic-transport-python";
    changelog = "https://github.com/elastic/elastic-transport-python/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
