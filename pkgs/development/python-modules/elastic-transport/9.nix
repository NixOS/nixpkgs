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
  pytest-httpbin,
  pytest-httpserver,
  pytestCheckHook,
  requests,
  respx,
  setuptools,
  sniffio,
  trustme,
  urllib3,
}:

buildPythonPackage (finalAttrs: {
  pname = "elastic-transport";
  version = "9.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "elastic";
    repo = "elastic-transport-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bbqLpVRgWAaK27Uy0ch1f1Y2T0C+zFjqyH7TsuIdQUs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    certifi
    sniffio
    urllib3
  ];

  nativeCheckInputs = [
    aiohttp
    mock
    opentelemetry-api
    opentelemetry-sdk
    orjson
    pytest-asyncio
    pytest-cov-stub
    pytest-httpbin
    pytest-httpserver
    pytestCheckHook
    requests
    respx
    trustme
  ];

  pythonImportsCheck = [ "elastic_transport" ];

  pytestFlags = [
    "-Wignore::DeprecationWarning"
  ];

  disabledTestPaths = [
    "tests/node/test_tls_versions.py"
    "tests/node/test_urllib3_chain_certs.py::test_assert_fingerprint_in_cert_chain_failure"
    "tests/test_logging.py::test_debug_logging"
  ];

  meta = {
    description = "Transport classes and utilities shared among Python Elastic client libraries";
    homepage = "https://github.com/elastic/elastic-transport-python";
    changelog = "https://github.com/elastic/elastic-transport-python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
