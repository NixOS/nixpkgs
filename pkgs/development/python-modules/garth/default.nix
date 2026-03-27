{
  lib,
  buildPythonPackage,
  fetchPypi,
  freezegun,
  hatchling,
  logfire,
  pydantic-settings,
  pydantic,
  pytest-vcr,
  pytestCheckHook,
  requests-oauthlib,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "garth";
  version = "0.7.9";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-vLNoLl6Z5w7n6u//desPqtgRCqEx66T/EiLXcFDN6Z4=";
  };

  pythonRelaxDeps = [ "requests-oauthlib" ];

  build-system = [ hatchling ];

  dependencies = [
    logfire
    pydantic
    pydantic-settings
    requests
    requests-oauthlib
  ];

  nativeCheckInputs = [
    freezegun
    pytest-vcr
    pytestCheckHook
  ];

  pythonImportsCheck = [ "garth" ];

  disabledTests = [
    # Tests require network access
    "test_client_request"
    "test_connectapi"
    "test_daily"
    "test_download"
    "test_exchange"
    "test_hrv_data_get"
    "test_login"
    "test_refresh_oauth2_token"
    "test_sleep_data"
    "test_username"
    "test_weekly"
    # Telemetry mock not working out, no idea
    "test_telemetry_env_enabled_with_mock"
    "test_default_callback_calls_logfire"
  ];

  meta = {
    description = "Garmin SSO auth and connect client";
    homepage = "https://github.com/matin/garth";
    changelog = "https://github.com/matin/garth/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
