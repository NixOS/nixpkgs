{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  pydantic,
  pytest-vcr,
  pytestCheckHook,
  requests,
  requests-oauthlib,
}:

buildPythonPackage rec {
  pname = "garth";
<<<<<<< HEAD
  version = "0.5.20";
=======
  version = "0.5.19";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-dqn/SeLQMT+6XOr65hlavZf1zdHnICKm9VCFh9DMLpk=";
=======
    hash = "sha256-no9qxDtk6k5YXOEwFfwPJb4EylQRKOGorVIgvhwd4dY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  pythonRelaxDeps = [ "requests-oauthlib" ];

  build-system = [ hatchling ];

  dependencies = [
    pydantic
    requests
    requests-oauthlib
  ];

  nativeCheckInputs = [
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
  ];

<<<<<<< HEAD
  meta = {
    description = "Garmin SSO auth and connect client";
    homepage = "https://github.com/matin/garth";
    changelog = "https://github.com/matin/garth/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Garmin SSO auth and connect client";
    homepage = "https://github.com/matin/garth";
    changelog = "https://github.com/matin/garth/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
