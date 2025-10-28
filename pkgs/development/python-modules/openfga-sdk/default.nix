{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,
  pytestCheckHook,
  aiohttp,
  build,
  mock,
  opentelemetry-api,
  pytest-asyncio,
  pytest-cov-stub,
  python-dateutil,
  setuptools,
  urllib3,
}:

buildPythonPackage rec {
  pname = "openfga-sdk";
  version = "0.9.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openfga";
    repo = "python-sdk";
    tag = "v${version}";
    hash = "sha256-e/Pgyj7A1HtcDPeRy0QK+Nok2ruWBiU9A1Yh7RZvtVI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    build
    opentelemetry-api
    python-dateutil
    urllib3
  ];

  pythonImportsCheck = [ "openfga_sdk" ];

  nativeCheckInputs = [
    mock
    pytest-cov-stub
    pytestCheckHook
  ]
  ++ lib.optionals (pythonAtLeast "3.13") [ pytest-asyncio ];

  disabledTests = lib.optionals (pythonAtLeast "3.13") [
    # These fail due to a race condition in the test mocks
    "test_client_batch_check_multiple_request"
    "test_client_batch_check_multiple_request_fail"
  ];

  meta = {
    changelog = "https://github.com/openfga/python-sdk/blob/${src.tag}/CHANGELOG.md";
    description = "Fine-Grained Authorization solution for Python";
    homepage = "https://github.com/openfga/python-sdk";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nicklewis ];
  };
}
