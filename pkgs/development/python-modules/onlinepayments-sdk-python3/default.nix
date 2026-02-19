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
  version = "7.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wl-online-payments-direct";
    repo = "sdk-python3";
    rev = finalAttrs.version;
    hash = "sha256-0w3PdnmLpp+1MzpwetTKY7bPNb9mNJAqKjs4mqdjsRM=";
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
