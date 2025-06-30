{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  aiodns,
  aiohttp,
  aresponses,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-freezer,
  pytestCheckHook,
  syrupy,
  yarl,
}:

buildPythonPackage rec {
  pname = "forecast-solar";
  version = "4.2.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "forecast_solar";
    tag = "v${version}";
    hash = "sha256-ZBkuhONvn1/QpD+ml3HJinMIdg1HFpVj5KZAlUt/qR4=";
  };

  build-system = [ poetry-core ];

  env.PACKAGE_VERSION = version;

  dependencies = [
    aiodns
    aiohttp
    yarl
  ];

  pythonImportsCheck = [ "forecast_solar" ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytest-cov-stub
    pytest-freezer
    pytestCheckHook
    syrupy
  ];

  disabledTests = [
    # "Error while resolving Forecast.Solar API address"
    "test_api_key_validation"
    "test_estimated_forecast"
    "test_internal_session"
    "test_json_request"
    "test_plane_validation"
    "test_status_400"
    "test_status_401"
    "test_status_422"
    "test_status_429"
  ];

  meta = with lib; {
    changelog = "https://github.com/home-assistant-libs/forecast_solar/releases/tag/v${version}";
    description = "Asynchronous Python client for getting forecast solar information";
    homepage = "https://github.com/home-assistant-libs/forecast_solar";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
