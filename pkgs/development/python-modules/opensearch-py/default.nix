{ aiohttp
, botocore
, buildPythonPackage
, certifi
, fetchFromGitHub
, lib
, mock
, pytest-asyncio
, pytestCheckHook
, pyyaml
, requests
, urllib3
}:

buildPythonPackage rec {
  pname = "opensearch-py";
  version = "2.3.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "opensearch-project";
    repo = "opensearch-py";
    rev = "refs/tags/v${version}";
    hash = "sha256-MkrYCi/iz1OqqrwCZknfcZSEyZNPj+CZFiMycJQk+aQ=";
  };

  propagatedBuildInputs = [
    botocore
    certifi
    requests
    urllib3
  ];

  nativeCheckInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
    pyyaml
  ] ++ passthru.optional-dependencies.async;

  disabledTestPaths = [
    # require network
    "test_opensearchpy/test_async/test_connection.py"
    "test_opensearchpy/test_async/test_server"
    "test_opensearchpy/test_connection.py"
    "test_opensearchpy/test_server"
    "test_opensearchpy/test_server_secured"
  ];

  passthru.optional-dependencies.async = [ aiohttp ];

  meta = {
    description = "Python low-level client for OpenSearch";
    homepage = "https://github.com/opensearch-project/opensearch-py";
    changelog = "https://github.com/opensearch-project/opensearch-py/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mcwitt ];
  };
}
