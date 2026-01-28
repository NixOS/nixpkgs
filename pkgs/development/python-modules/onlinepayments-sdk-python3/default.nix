{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
  requests-toolbelt,
  mockito,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "onlinepayments-sdk-python3";
  version = "6.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wl-online-payments-direct";
    repo = "sdk-python3";
    rev = finalAttrs.version;
    hash = "sha256-SjGv3g7c1Vw2li5FP3PLzXvy22fuT6cMJaNIbA9MnOg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    requests-toolbelt
  ];

  nativeCheckInputs = [
    mockito
    pytestCheckHook
  ];

  disabledTestPaths = [
    # requires api key
    "tests/integration"
  ];

  disabledTests = [
    # missing fixtures
    "testConnection_request"
    "testConnection_response"
  ];

  pythonImportsCheck = [
    "onlinepayments"
  ];

  meta = {
    description = "SDK to communicate with the Online Payments platform using the Online Payments Server API";
    homepage = "https://github.com/wl-online-payments-direct/sdk-python3";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
