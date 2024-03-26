{ lib
, buildPythonPackage
, fetchPypi
, pdm-backend
, pydantic
, pytest-vcr
, pytestCheckHook
, pythonOlder
, requests
, requests-oauthlib
}:

buildPythonPackage rec {
  pname = "garth";
  version = "0.4.45";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dN4WQZ2FLkyqCGYFBICodHR7yBdrLvx4NE6OqB0SgZo=";
  };

  nativeBuildInputs = [
    pdm-backend
  ];

  propagatedBuildInputs = [
    pydantic
    requests
    requests-oauthlib
  ];

  nativeCheckInputs = [
    pytest-vcr
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "garth"
  ];

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
  ];

  meta = with lib; {
    description = "Garmin SSO auth and connect client";
    homepage = "https://github.com/matin/garth";
    changelog = "https://github.com/matin/garth/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
