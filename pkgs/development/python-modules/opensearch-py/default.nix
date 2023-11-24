{ lib
, buildPythonPackage
, fetchFromGitHub

# build-system
, setuptools

# dependencies
, certifi
, python-dateutil
, requests
, six
, urllib3

# optional-dependencies
, aiohttp

# tests
, botocore
, mock
, pytest-asyncio
, pytest-mock
, pytestCheckHook
, pyyaml
, pytz
}:

buildPythonPackage rec {
  pname = "opensearch-py";
  version = "2.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "opensearch-project";
    repo = "opensearch-py";
    rev = "refs/tags/v${version}";
    hash = "sha256-MPuHdjhsrccKYUIDlDYGoXBbBu/V+q43Puf0e5j8vhU=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    certifi
    python-dateutil
    requests
    six
    urllib3
  ];

  passthru.optional-dependencies.async = [
    aiohttp
  ];

  nativeCheckInputs = [
    botocore
    mock
    pytest-asyncio
    pytest-mock
    pytestCheckHook
    pyyaml
    pytz
  ] ++ passthru.optional-dependencies.async;

  disabledTestPaths = [
    # require network
    "test_opensearchpy/test_async/test_connection.py"
    "test_opensearchpy/test_async/test_server"
    "test_opensearchpy/test_server"
    "test_opensearchpy/test_server_secured"
  ];

  disabledTests = [
    # finds our ca-bundle, but expects something else (/path/to/clientcert/dir or None)
    "test_ca_certs_ssl_cert_dir"
    "test_no_ca_certs"
  ];

  meta = {
    description = "Python low-level client for OpenSearch";
    homepage = "https://github.com/opensearch-project/opensearch-py";
    changelog = "https://github.com/opensearch-project/opensearch-py/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mcwitt ];
  };
}
