{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pycryptodome,
  requests,
  setuptools,
  websocket-client,
  # dependencies for tests
  pytest-cov-stub,
  sure,
  responses,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "binance-connector";
  version = "3.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "binance";
    repo = "${pname}-python";
    tag = "v${version}";
    hash = "sha256-8O73+fli0HNbvGBcyg79ZGOTQvL0TF5SCfogI6btlrA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    pycryptodome
    websocket-client
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    sure
    responses
    pytestCheckHook
  ];

  # pytestCheckHook attempts to run examples directory, which requires
  # network access
  disabledTestPaths = [ "examples/" ];

  pythonImportsCheck = [
    "binance.spot"
    "binance.websocket"
  ];

  meta = {
    description = "Simple connector to Binance Public API";
    homepage = "https://github.com/binance/binance-connector-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ trishtzy ];
  };
}
