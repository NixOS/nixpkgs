{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,

  # build-system
  setuptools,

  # dependencies
  certifi,
  python-dateutil,
  requests,
  six,
  urllib3,
  events,

  # optional-dependencies
  aiohttp,

  # tests
  botocore,
  mock,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  pyyaml,
  pytz,
}:

buildPythonPackage rec {
  pname = "opensearch-py";
  version = "2.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "opensearch-project";
    repo = "opensearch-py";
    rev = "refs/tags/v${version}";
    hash = "sha256-GC0waXxHRiXVXjhTGbet3HvDKmUBKzoufu/J4fmrM+k=";
  };

  patches = [
    (fetchpatch2 {
      name = "opensearch-py-aiohttp-3.10.6-compat.patch";
      url = "https://github.com/opensearch-project/opensearch-py/commit/0ccd4173cc49b8e15d2c2f1a5fa7459f6e390a86.patch";
      excludes = [
        "dev-requirements.txt"
      ];
      hash = "sha256-qqS3Nw03q6U3UW1sgQZV3l9SB/Y6Q/RllarTAANgj2A=";
    })
  ];

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    certifi
    python-dateutil
    requests
    six
    urllib3
    events
  ];

  optional-dependencies.async = [ aiohttp ];

  nativeCheckInputs = [
    botocore
    mock
    pytest-asyncio
    pytest-mock
    pytestCheckHook
    pyyaml
    pytz
  ] ++ optional-dependencies.async;

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
