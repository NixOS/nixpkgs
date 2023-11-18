{ lib
, aiohttp
, buildPythonPackage
, certifi
, fetchFromGitHub
, mock
, pytest-asyncio
, pytest-httpserver
, pytestCheckHook
, pythonOlder
, requests
, trustme
, urllib3
}:

buildPythonPackage rec {
  pname = "elastic-transport";
  version = "8.4.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "elastic";
    repo = "elastic-transport-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-hrI8GJaI3K/3B0Vng0WvoabDP2Y8/60/tHNKo/Xq6JM=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace " --cov-report=term-missing --cov=elastic_transport" ""
  '';

  propagatedBuildInputs = [
    urllib3
    certifi
  ];

  nativeCheckInputs = [
    aiohttp
    mock
    pytest-asyncio
    pytest-httpserver
    pytestCheckHook
    requests
    trustme
  ];

  pythonImportsCheck = [
    "elastic_transport"
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
  ];

  meta = with lib; {
    description = "Transport classes and utilities shared among Python Elastic client libraries";
    homepage = "https://github.com/elasticsearch/elastic-transport-python";
    changelog = "https://github.com/elastic/elastic-transport-python/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
