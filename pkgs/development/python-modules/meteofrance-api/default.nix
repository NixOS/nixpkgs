{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
  pytz,
  requests,
  requests-mock,
}:

buildPythonPackage rec {
  pname = "meteofrance-api";
  version = "1.4.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "hacf-fr";
    repo = "meteofrance-api";
    tag = "v${version}";
    hash = "sha256-5zqmzPbzC9IUZ+y1FRh+u1gds/ZdGeRm5/ajQf8UKTQ=";
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

  meta = with lib; {
    description = "Module to access information from the Meteo-France API";
    homepage = "https://github.com/hacf-fr/meteofrance-api";
    changelog = "https://github.com/hacf-fr/meteofrance-api/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "meteofrance-api";
  };
}
