{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

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

  __darwinAllowLocalNetworking = true;

  disabledTestPaths = [
    # require network
    "test_opensearchpy/test_async/test_connection.py"
    "test_opensearchpy/test_async/test_server"
    "test_opensearchpy/test_server"
    "test_opensearchpy/test_server_secured"
  ];

  disabledTests =
    [
      # finds our ca-bundle, but expects something else (/path/to/clientcert/dir or None)
      "test_ca_certs_ssl_cert_dir"
      "test_no_ca_certs"

      # Failing tests, issue opened at https://github.com/opensearch-project/opensearch-py/issues/849
      "test_basicauth_in_request_session"
      "test_callable_in_request_session"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86) [
      # Flaky tests: OSError: [Errno 48] Address already in use
      "test_redirect_failure_when_allow_redirect_false"
      "test_redirect_success_when_allow_redirect_true"
    ];

  meta = {
    description = "Python low-level client for OpenSearch";
    homepage = "https://github.com/opensearch-project/opensearch-py";
    changelog = "https://github.com/opensearch-project/opensearch-py/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mcwitt ];
  };
}
