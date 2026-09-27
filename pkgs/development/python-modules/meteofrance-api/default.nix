{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pytz,
  requests,
  requests-mock,
}:

buildPythonPackage (finalAttrs: {
  pname = "meteofrance-api";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hacf-fr";
    repo = "meteofrance-api";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zvfFMxXbCul14OXaoRdjMWKW3FYyTUcYGklHgb04nvA=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    pytz
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [ "meteofrance_api" ];

  disabledTests = [
    # Tests require network access
    "test_currentphenomenons"
    "test_dictionary"
    "test_forecast"
    "test_full_with_coastal_bulletin"
    "test_fulls"
    "test_no_rain_expected"
    "test_picture_of_the_day"
    "test_places"
    "test_rain"
    "test_session"
    "test_observation"
    "test_workflow"
  ];

  meta = {
    description = "Module to access information from the Meteo-France API";
    homepage = "https://github.com/hacf-fr/meteofrance-api";
    changelog = "https://github.com/hacf-fr/meteofrance-api/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "meteofrance-api";
  };
})
